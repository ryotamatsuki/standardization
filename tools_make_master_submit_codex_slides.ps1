param(
    [string]$OutFile = 'master_submit_codex_slides.pptx'
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Write-Utf8File {
    param(
        [string]$Path,
        [string]$Content
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Escape-XmlText {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    return [System.Security.SecurityElement]::Escape($Text)
}

function Get-ParagraphXml {
    param(
        [string]$Text,
        [int]$Size,
        [bool]$Bold = $false,
        [string]$Color = '333333',
        [bool]$Center = $false
    )

    $escaped = Escape-XmlText $Text
    $boldAttr = if ($Bold) { ' b="1"' } else { '' }
    $align = if ($Center) { 'ctr' } else { 'l' }
    return @"
<a:p>
  <a:pPr algn="$align"/>
  <a:r>
    <a:rPr lang="ja-JP" sz="$Size"$boldAttr dirty="0" smtClean="0">
      <a:solidFill><a:srgbClr val="$Color"/></a:solidFill>
    </a:rPr>
    <a:t>$escaped</a:t>
  </a:r>
  <a:endParaRPr lang="ja-JP" sz="$Size" dirty="0"/>
</a:p>
"@
}

function Get-TextShapeXml {
    param(
        [int]$Id,
        [string]$Name,
        [int]$X,
        [int]$Y,
        [int]$Cx,
        [int]$Cy,
        [string[]]$Paragraphs,
        [int]$Size,
        [bool]$Bold = $false,
        [string]$Color = '333333',
        [bool]$Center = $false
    )

    $paragraphXml = ($Paragraphs | ForEach-Object {
        Get-ParagraphXml -Text $_ -Size $Size -Bold $Bold -Color $Color -Center $Center
    }) -join "`n"

    return @"
<p:sp>
  <p:nvSpPr>
    <p:cNvPr id="$Id" name="$Name"/>
    <p:cNvSpPr txBox="1"/>
    <p:nvPr/>
  </p:nvSpPr>
  <p:spPr>
    <a:xfrm>
      <a:off x="$X" y="$Y"/>
      <a:ext cx="$Cx" cy="$Cy"/>
    </a:xfrm>
    <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
    <a:noFill/>
    <a:ln><a:noFill/></a:ln>
  </p:spPr>
  <p:txBody>
    <a:bodyPr wrap="square" rtlCol="0" anchor="t" lIns="0" tIns="0" rIns="0" bIns="0"/>
    <a:lstStyle/>
$paragraphXml
  </p:txBody>
</p:sp>
"@
}

function Get-SlideXml {
    param(
        [pscustomobject]$Slide,
        [int]$Index,
        [int]$Total
    )

    $groupXml = @"
<p:nvGrpSpPr>
  <p:cNvPr id="1" name=""/>
  <p:cNvGrpSpPr/>
  <p:nvPr/>
</p:nvGrpSpPr>
<p:grpSpPr>
  <a:xfrm>
    <a:off x="0" y="0"/>
    <a:ext cx="0" cy="0"/>
    <a:chOff x="0" y="0"/>
    <a:chExt cx="0" cy="0"/>
  </a:xfrm>
</p:grpSpPr>
"@

    if ($Slide.Type -eq 'title') {
        $shapes = @(
            Get-TextShapeXml -Id 2 -Name 'Title' -X 700000 -Y 520000 -Cx 10800000 -Cy 1200000 -Paragraphs @($Slide.Title) -Size 2600 -Bold $true -Color '143A52' -Center $true
            Get-TextShapeXml -Id 3 -Name 'Subtitle' -X 900000 -Y 1800000 -Cx 10400000 -Cy 900000 -Paragraphs @($Slide.Subtitle) -Size 1500 -Bold $false -Color '4F5D75' -Center $true
            Get-TextShapeXml -Id 4 -Name 'Meta' -X 1200000 -Y 2800000 -Cx 9800000 -Cy 1800000 -Paragraphs $Slide.Meta -Size 1500 -Bold $false -Color '2F3A4A' -Center $true
        ) -join "`n"
    }
    else {
        $bodySize = if ($Slide.PSObject.Properties.Name -contains 'BodySize') { [int]$Slide.BodySize } else { 1850 }
        $shapes = @(
            Get-TextShapeXml -Id 2 -Name 'Title' -X 650000 -Y 350000 -Cx 10800000 -Cy 700000 -Paragraphs @($Slide.Title) -Size 2400 -Bold $true -Color '143A52' -Center $false
            Get-TextShapeXml -Id 3 -Name 'Body' -X 750000 -Y 1350000 -Cx 10600000 -Cy 4300000 -Paragraphs $Slide.Body -Size $bodySize -Bold $false -Color '333333' -Center $false
            Get-TextShapeXml -Id 4 -Name 'Footer' -X 750000 -Y 6250000 -Cx 10600000 -Cy 180000 -Paragraphs @("$($Index + 1) / $Total    応用経済学会報告用スライド    codex") -Size 950 -Bold $false -Color '7A7A7A' -Center $false
        ) -join "`n"
    }

    return @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
       xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld name="Slide $($Index + 1)">
    <p:spTree>
$groupXml
$shapes
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr>
    <a:masterClrMapping/>
  </p:clrMapOvr>
</p:sld>
"@
}

function Get-SlideRelsXml {
    return @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1"
                Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"
                Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>
"@
}

$slides = @(
    [pscustomobject]@{
        Type = 'title';
        Title = '国際標準化で「加盟」と「実効的参加」は同じか？';
        Subtitle = 'Participation Capacity, Standards Blocs, and Inefficient International Standardization';
        Meta = @(
            'Ryota Matsuki',
            '応用経済学会報告用',
            '初見の経済学者向けサマリー',
            'master_submit.pdf / codex'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '問題意識';
        Body = @(
            '・標準の統一は、互換性・市場統合・ネットワーク効果を高めるはずである',
            '・しかし、相互承認しても「入っただけで十分に参加できない国」がある',
            '・本稿の問いは、完全標準化がなぜ止まり、何がその壁を下げるかである'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '本稿のコアアイデア';
        Body = @(
            '・formal accession と effective participation を区別する',
            '・参加能力 θ_k が低い国では、残余コンプライアンス費用 τ_k = μ(1−θ_k) が残る',
            '・相互承認で技術差コスト c は消えても、実効的な参加の格差は残る'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = 'モデルの骨格';
        Body = @(
            '・3国 A, B, C と各1企業、各市場は分断、企業は Cournot 競争',
            '・A と B は高能力、C は低能力という非対称性を置く',
            '・政府は標準化レジームを選び、後半で参加能力投資も考える',
            '・焦点は「弱い国 C を共通標準に入れるかどうか」である'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '3つの標準化レジーム';
        Body = @(
            '・SW: 各国が自国標準を維持する',
            '・SU: A-B だけが標準化ユニオンを作り、C は外部に残る',
            '・IS: 3国全体が共通標準に入る',
            '・SU から IS に進むには、C が参加したいことと A,B が受け入れることの両方が必要'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '結果1: 世界厚生と均衡レジームはズレうる';
        Body = @(
            '・IS が世界厚生を最大化しても、均衡は SU にとどまりうる',
            '・低能力国 C は、A,B から見ると共通ネットワークへの寄与が小さい',
            '・一方で、加盟後に A,B 市場で受ける競争圧力は確実に増える',
            '・非効率な排除は、保護主義だけでなく能力格差からも生じる'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '結果2: ネットワーク効果は常に統合を促すわけではない';
        Body = @(
            '・ネットワーク効果 v が強いほど IS が有利、とは限らない',
            '・能力格差が大きいと、既存ブロックを維持する価値も上がる',
            '・その結果、強い v が排他的な SU を安定化させることがある'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '結果3: 何が政策的に効くか';
        Body = @(
            '・C 側の能力投資や条件付き移転は、accession margin を直接緩める',
            '・単に fragmentation を維持する政策より、能力構築の方が有効である',
            '・ただし政策結果は verified compact domain 上の条件付き結果である'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = 'なぜ応用経済学に重要か';
        Body = @(
            '・標準化は IO だけでなく、trade policy・industrial policy・development policy の問題でもある',
            '・法的アクセスがあっても、testing・certification・implementation capacity がなければ統合は進まない',
            '・MRA、TBT、能力構築支援を考える際のメカニズムを与える'
        );
        BodySize = 1750;
    },
    [pscustomobject]@{
        Type = 'body';
        Title = 'この論文の新規性';
        Body = @(
            '・compatibility / network externalities の文献を、国際標準化の accession problem に接続した',
            '・mutual recognition を「法的加盟はできても実効参加は不完全」という形で捉えた',
            '・bloc formation と capacity gap を一つの理論枠組みに置いた'
        );
    },
    [pscustomobject]@{
        Type = 'body';
        Title = '限界と読み方';
        Body = @(
            '・A-B 先行の連合形成を置いており、一般的な coalition formation model ではない',
            '・主要結果の一部は数値例と閾値表現に依拠している',
            '・政策部は局所領域の結果であり、普遍定理として読むべきではない',
            '・したがって本稿は「機構の提示」と「政策ベンチマーク」として読むのが適切である'
        );
        BodySize = 1725;
    },
    [pscustomobject]@{
        Type = 'body';
        Title = 'Takeaway';
        Body = @(
            '・1. 加盟と実効的参加は別物である',
            '・2. 世界的に望ましい IS でも、均衡は排他的 bloc にとどまりうる',
            '・3. fragmentation 解消の鍵は legal recognition より participation capacity にある',
            '・ご質問・コメント歓迎'
        );
    }
)

$root = (Get-Location).Path
$outPath = Join-Path $root $OutFile
$zipPath = [System.IO.Path]::ChangeExtension($outPath, '.zip')
$workDir = Join-Path $root ("_codex_pptx_build_" + [guid]::NewGuid().ToString('N'))

if (Test-Path $workDir) {
    Remove-Item $workDir -Recurse -Force
}

$dirs = @(
    '_rels',
    'docProps',
    'ppt',
    'ppt/_rels',
    'ppt/slideMasters',
    'ppt/slideMasters/_rels',
    'ppt/slideLayouts',
    'ppt/slides',
    'ppt/slides/_rels',
    'ppt/theme'
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path (Join-Path $workDir $dir) | Out-Null
}

$slideOverrides = ($slides | ForEach-Object -Begin { $i = 1 } -Process {
    $xml = "<Override PartName=`"/ppt/slides/slide$($i).xml`" ContentType=`"application/vnd.openxmlformats-officedocument.presentationml.slide+xml`"/>"
    $i++
    $xml
}) -join "`n  "

$slideRelEntries = ($slides | ForEach-Object -Begin { $i = 1 } -Process {
    $id = 255 + $i
    $xml = "<p:sldId id=`"$id`" r:id=`"rId$($i + 1)`"/>"
    $i++
    $xml
}) -join "`n    "

$presentationRels = @(
    '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>'
)

for ($i = 1; $i -le $slides.Count; $i++) {
    $presentationRels += "<Relationship Id=`"rId$($i + 1)`" Type=`"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide`" Target=`"slides/slide$($i).xml`"/>"
}

$presentationRelsXml = $presentationRels -join "`n  "

$slideTitlesVector = ($slides | ForEach-Object {
    "<vt:lpstr>$(Escape-XmlText $_.Title)</vt:lpstr>"
}) -join "`n      "

$utcNow = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

$contentTypesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
  <Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
  <Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
  <Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
  $slideOverrides
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
"@

$rootRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
"@

$appXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"
            xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
  <Application>Microsoft Office PowerPoint</Application>
  <PresentationFormat>On-screen Show (16:9)</PresentationFormat>
  <Slides>$($slides.Count)</Slides>
  <Notes>0</Notes>
  <HiddenSlides>0</HiddenSlides>
  <MMClips>0</MMClips>
  <ScaleCrop>false</ScaleCrop>
  <HeadingPairs>
    <vt:vector size="2" baseType="variant">
      <vt:variant><vt:lpstr>テーマ</vt:lpstr></vt:variant>
      <vt:variant><vt:i4>$($slides.Count)</vt:i4></vt:variant>
    </vt:vector>
  </HeadingPairs>
  <TitlesOfParts>
    <vt:vector size="$($slides.Count)" baseType="lpstr">
      $slideTitlesVector
    </vt:vector>
  </TitlesOfParts>
  <Company></Company>
  <LinksUpToDate>false</LinksUpToDate>
  <SharedDoc>false</SharedDoc>
  <HyperlinksChanged>false</HyperlinksChanged>
  <AppVersion>16.0000</AppVersion>
</Properties>
"@

$coreXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                   xmlns:dc="http://purl.org/dc/elements/1.1/"
                   xmlns:dcterms="http://purl.org/dc/terms/"
                   xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>master_submit_codex_slides</dc:title>
  <dc:creator>Ryota Matsuki</dc:creator>
  <cp:lastModifiedBy>Codex</cp:lastModifiedBy>
  <dcterms:created xsi:type="dcterms:W3CDTF">$utcNow</dcterms:created>
  <dcterms:modified xsi:type="dcterms:W3CDTF">$utcNow</dcterms:modified>
</cp:coreProperties>
"@

$presentationXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
                saveSubsetFonts="1"
                autoCompressPictures="0">
  <p:sldMasterIdLst>
    <p:sldMasterId id="2147483648" r:id="rId1"/>
  </p:sldMasterIdLst>
  <p:sldIdLst>
    $slideRelEntries
  </p:sldIdLst>
  <p:sldSz cx="12192000" cy="6858000"/>
  <p:notesSz cx="6858000" cy="9144000"/>
  <p:defaultTextStyle>
    <a:defPPr/>
    <a:lvl1pPr marL="0" indent="0"/>
    <a:lvl2pPr marL="0" indent="0"/>
    <a:lvl3pPr marL="0" indent="0"/>
  </p:defaultTextStyle>
</p:presentation>
"@

$presentationRelsXmlFull = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  $presentationRelsXml
</Relationships>
"@

$slideMasterXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
             xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
             xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
  <p:cSld name="Slide Master">
    <p:bg>
      <p:bgPr>
        <a:solidFill><a:srgbClr val="FFFFFF"/></a:solidFill>
        <a:effectLst/>
      </p:bgPr>
    </p:bg>
    <p:spTree>
      <p:nvGrpSpPr>
        <p:cNvPr id="1" name=""/>
        <p:cNvGrpSpPr/>
        <p:nvPr/>
      </p:nvGrpSpPr>
      <p:grpSpPr>
        <a:xfrm>
          <a:off x="0" y="0"/>
          <a:ext cx="0" cy="0"/>
          <a:chOff x="0" y="0"/>
          <a:chExt cx="0" cy="0"/>
        </a:xfrm>
      </p:grpSpPr>
    </p:spTree>
  </p:cSld>
  <p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/>
  <p:sldLayoutIdLst>
    <p:sldLayoutId id="2147483649" r:id="rId1"/>
  </p:sldLayoutIdLst>
  <p:txStyles>
    <p:titleStyle/>
    <p:bodyStyle/>
    <p:otherStyle/>
  </p:txStyles>
</p:sldMaster>
"@

$slideMasterRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/>
</Relationships>
"@

$slideLayoutXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
             xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
             xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
             type="blank"
             preserve="1">
  <p:cSld name="Blank">
    <p:spTree>
      <p:nvGrpSpPr>
        <p:cNvPr id="1" name=""/>
        <p:cNvGrpSpPr/>
        <p:nvPr/>
      </p:nvGrpSpPr>
      <p:grpSpPr>
        <a:xfrm>
          <a:off x="0" y="0"/>
          <a:ext cx="0" cy="0"/>
          <a:chOff x="0" y="0"/>
          <a:chExt cx="0" cy="0"/>
        </a:xfrm>
      </p:grpSpPr>
    </p:spTree>
  </p:cSld>
  <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
</p:sldLayout>
"@

$themeXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Codex Theme">
  <a:themeElements>
    <a:clrScheme name="Codex Colors">
      <a:dk1><a:srgbClr val="1F2937"/></a:dk1>
      <a:lt1><a:srgbClr val="FFFFFF"/></a:lt1>
      <a:dk2><a:srgbClr val="374151"/></a:dk2>
      <a:lt2><a:srgbClr val="F7F8FA"/></a:lt2>
      <a:accent1><a:srgbClr val="1F7A8C"/></a:accent1>
      <a:accent2><a:srgbClr val="E07A5F"/></a:accent2>
      <a:accent3><a:srgbClr val="3D405B"/></a:accent3>
      <a:accent4><a:srgbClr val="81B29A"/></a:accent4>
      <a:accent5><a:srgbClr val="F2CC8F"/></a:accent5>
      <a:accent6><a:srgbClr val="C1666B"/></a:accent6>
      <a:hlink><a:srgbClr val="0563C1"/></a:hlink>
      <a:folHlink><a:srgbClr val="954F72"/></a:folHlink>
    </a:clrScheme>
    <a:fontScheme name="Codex Fonts">
      <a:majorFont>
        <a:latin typeface="Arial"/>
        <a:ea typeface="Yu Gothic"/>
        <a:cs typeface=""/>
      </a:majorFont>
      <a:minorFont>
        <a:latin typeface="Arial"/>
        <a:ea typeface="Yu Gothic"/>
        <a:cs typeface=""/>
      </a:minorFont>
    </a:fontScheme>
    <a:fmtScheme name="Codex Format">
      <a:fillStyleLst>
        <a:solidFill><a:schemeClr val="lt1"/></a:solidFill>
        <a:solidFill><a:schemeClr val="accent1"/></a:solidFill>
        <a:solidFill><a:schemeClr val="accent2"/></a:solidFill>
      </a:fillStyleLst>
      <a:lnStyleLst>
        <a:ln w="9525" cap="flat" cmpd="sng" algn="ctr">
          <a:solidFill><a:schemeClr val="accent1"/></a:solidFill>
          <a:prstDash val="solid"/>
        </a:ln>
        <a:ln w="25400" cap="flat" cmpd="sng" algn="ctr">
          <a:solidFill><a:schemeClr val="accent2"/></a:solidFill>
          <a:prstDash val="solid"/>
        </a:ln>
        <a:ln w="38100" cap="flat" cmpd="sng" algn="ctr">
          <a:solidFill><a:schemeClr val="accent3"/></a:solidFill>
          <a:prstDash val="solid"/>
        </a:ln>
      </a:lnStyleLst>
      <a:effectStyleLst>
        <a:effectStyle><a:effectLst/></a:effectStyle>
        <a:effectStyle><a:effectLst/></a:effectStyle>
        <a:effectStyle><a:effectLst/></a:effectStyle>
      </a:effectStyleLst>
      <a:bgFillStyleLst>
        <a:solidFill><a:schemeClr val="lt1"/></a:solidFill>
        <a:solidFill><a:schemeClr val="lt2"/></a:solidFill>
        <a:solidFill><a:schemeClr val="dk1"/></a:solidFill>
      </a:bgFillStyleLst>
    </a:fmtScheme>
  </a:themeElements>
  <a:objectDefaults/>
  <a:extraClrSchemeLst/>
</a:theme>
"@

Write-Utf8File -Path (Join-Path $workDir '[Content_Types].xml') -Content $contentTypesXml
Write-Utf8File -Path (Join-Path $workDir '_rels/.rels') -Content $rootRelsXml
Write-Utf8File -Path (Join-Path $workDir 'docProps/app.xml') -Content $appXml
Write-Utf8File -Path (Join-Path $workDir 'docProps/core.xml') -Content $coreXml
Write-Utf8File -Path (Join-Path $workDir 'ppt/presentation.xml') -Content $presentationXml
Write-Utf8File -Path (Join-Path $workDir 'ppt/_rels/presentation.xml.rels') -Content $presentationRelsXmlFull
Write-Utf8File -Path (Join-Path $workDir 'ppt/slideMasters/slideMaster1.xml') -Content $slideMasterXml
Write-Utf8File -Path (Join-Path $workDir 'ppt/slideMasters/_rels/slideMaster1.xml.rels') -Content $slideMasterRelsXml
Write-Utf8File -Path (Join-Path $workDir 'ppt/slideLayouts/slideLayout1.xml') -Content $slideLayoutXml
Write-Utf8File -Path (Join-Path $workDir 'ppt/theme/theme1.xml') -Content $themeXml

for ($i = 1; $i -le $slides.Count; $i++) {
    $slideXml = Get-SlideXml -Slide $slides[$i - 1] -Index ($i - 1) -Total $slides.Count
    $relsXml = Get-SlideRelsXml
    Write-Utf8File -Path (Join-Path $workDir "ppt/slides/slide$($i).xml") -Content $slideXml
    Write-Utf8File -Path (Join-Path $workDir "ppt/slides/_rels/slide$($i).xml.rels") -Content $relsXml
}

if (Test-Path $outPath) {
    Remove-Item $outPath -Force
}
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

[System.IO.Compression.ZipFile]::CreateFromDirectory($workDir, $zipPath)
Move-Item $zipPath $outPath -Force
Start-Sleep -Milliseconds 300
try {
    Remove-Item $workDir -Recurse -Force -ErrorAction Stop
}
catch {
    Write-Warning "Temporary build directory could not be removed: $workDir"
}

Write-Output "created=$outPath"
