import os
import sys

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
LOCAL_PACKAGES = os.path.join(PROJECT_ROOT, ".python_packages")
if os.path.isdir(LOCAL_PACKAGES) and LOCAL_PACKAGES not in sys.path:
    sys.path.insert(0, LOCAL_PACKAGES)

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import BoundaryNorm, ListedColormap
from matplotlib.lines import Line2D
from matplotlib.patches import Circle, FancyBboxPatch


REGIME_TO_CODE = {"SW": 0, "SU": 1, "IS": 2}
REGIME_CMAP = ListedColormap(["#d9d9d9", "#fdae61", "#2b83ba"])
REGIME_CMAP.set_bad(color="white")
REGIME_NORM = BoundaryNorm([-0.5, 0.5, 1.5, 2.5], REGIME_CMAP.N)


def sw_quantities(c, tau, tau_c):
    x = (1 + 2 * c + tau + tau_c) / 4
    y = (1 - 2 * c - 3 * tau + tau_c) / 4
    z = (1 - 2 * c + tau - 3 * tau_c) / 4
    w = (1 - 2 * c - 2 * tau) / 4
    t = (1 + 2 * c + 2 * tau) / 4
    q_a = x + y + z
    q_c = 2 * w + t
    return {"x": x, "y": y, "z": z, "w": w, "t": t, "QA": q_a, "QC": q_c}


def su_quantities(v, c, tau, tau_c):
    d_su = (2 - v) * (2 - 7 * v)
    xi_x = (
        7 * c * v**2
        - 9 * c * v
        + 2 * c
        + 8 * tau * v**2
        - 15 * tau * v
        + 2 * tau
        + 3 * tau_c * v**2
        - 5 * tau_c * v
        + 2 * tau_c
        + v**2
        - 3 * v
        + 2
    )
    xi_y = (
        7 * c * v**2
        - 9 * c * v
        + 2 * c
        - 6 * tau * v**2
        + 17 * tau * v
        - 6 * tau
        + 3 * tau_c * v**2
        - 5 * tau_c * v
        + 2 * tau_c
        + v**2
        - 3 * v
        + 2
    )
    xi_z = (
        -7 * c * v**2
        + 23 * c * v
        - 6 * c
        + tau * v
        + 2 * tau
        - 7 * tau_c * v**2
        + 19 * tau_c * v
        - 6 * tau_c
        + 7 * v**2
        - 15 * v
        + 2
    )
    xi_w = 14 * c * v - 4 * c + 6 * tau * v - 4 * tau + 4 * tau_c * v - v + 2
    xi_t = -14 * c * v + 4 * c - 6 * tau * v + 4 * tau - 4 * tau_c * v + 7 * v**2 - 15 * v + 2
    x = xi_x / (2 * (1 - v) * d_su)
    y = xi_y / (2 * (1 - v) * d_su)
    z = xi_z / (2 * d_su)
    w = xi_w / (2 * d_su)
    t = xi_t / (2 * d_su)
    q_a = (
        -7 * c * v**2
        + 9 * c * v
        - 2 * c
        - tau * v
        - 2 * tau
        - 7 * tau_c * v**2
        + 13 * tau_c * v
        - 2 * tau_c
        + 7 * v**2
        - 17 * v
        + 6
    ) / (2 * d_su)
    q_c = (14 * c * v - 4 * c + 6 * tau * v - 4 * tau + 4 * tau_c * v + 7 * v**2 - 17 * v + 6) / (2 * d_su)
    return {"x": x, "y": y, "z": z, "w": w, "t": t, "QA": q_a, "QC": q_c}


def is_quantities(v, tau, tau_c):
    d_is = (4 - v) * (2 - 5 * v)
    xi_x = 4 * tau * v**2 - 14 * tau * v + 4 * tau + 2 * tau_c * v**2 - 12 * tau_c * v + 4 * tau_c + v**2 - 5 * v + 4
    xi_y = -6 * tau * v**2 + 30 * tau * v - 12 * tau + 2 * tau_c * v**2 - 12 * tau_c * v + 4 * tau_c + v**2 - 5 * v + 4
    xi_z = 4 * tau * v**2 - 14 * tau * v + 4 * tau - 8 * tau_c * v**2 + 32 * tau_c * v - 12 * tau_c + v**2 - 5 * v + 4
    xi_w = -6 * tau * v**2 + 20 * tau * v - 8 * tau + 2 * tau_c * v**2 - 2 * tau_c * v + v**2 - 5 * v + 4
    xi_t = 4 * tau * v**2 - 24 * tau * v + 8 * tau + 2 * tau_c * v**2 - 2 * tau_c * v + v**2 - 5 * v + 4
    x = xi_x / (2 * (1 - v) * d_is)
    y = xi_y / (2 * (1 - v) * d_is)
    z = xi_z / (2 * (1 - v) * d_is)
    w = xi_w / (2 * (1 - v) * d_is)
    t = xi_t / (2 * (1 - v) * d_is)
    q_a = (12 - 3 * v - 4 * tau - 2 * tau * v - 4 * tau_c + 4 * tau_c * v) / (2 * d_is)
    q_c = (12 - 3 * v - 8 * tau + 8 * tau * v - 6 * tau_c * v) / (2 * d_is)
    return {"x": x, "y": y, "z": z, "w": w, "t": t, "QA": q_a, "QC": q_c}


def welfare_sw(c, tau, tau_c):
    q = sw_quantities(c, tau, tau_c)
    pi_a = q["x"] ** 2 + q["y"] ** 2 + q["w"] ** 2
    pi_c = 2 * q["z"] ** 2 + q["t"] ** 2
    w_a = q["QA"] ** 2 / 2 + pi_a
    w_c = q["QC"] ** 2 / 2 + pi_c
    return {"WA": w_a, "WC": w_c, "W": 2 * w_a + w_c}


def welfare_su(v, c, tau, tau_c):
    q = su_quantities(v, c, tau, tau_c)
    pi_a = (1 - v) * (q["x"] ** 2 + q["y"] ** 2 + q["w"] ** 2)
    pi_c = 2 * q["z"] ** 2 + q["t"] ** 2
    w_a = q["QA"] ** 2 / 2 + pi_a
    w_c = q["QC"] ** 2 / 2 + pi_c
    return {"WA": w_a, "WC": w_c, "W": 2 * w_a + w_c}


def welfare_is(v, tau, tau_c):
    q = is_quantities(v, tau, tau_c)
    pi_a = (1 - v) * (q["x"] ** 2 + q["y"] ** 2 + q["w"] ** 2)
    pi_c = (1 - v) * (2 * q["z"] ** 2 + q["t"] ** 2)
    w_a = q["QA"] ** 2 / 2 + pi_a
    w_c = q["QC"] ** 2 / 2 + pi_c
    return {"WA": w_a, "WC": w_c, "W": 2 * w_a + w_c}


def deltas(v, c, tau, tau_c):
    sw = welfare_sw(c, tau, tau_c)
    su = welfare_su(v, c, tau, tau_c)
    is_ = welfare_is(v, tau, tau_c)
    return {
        "dIA": is_["WA"] - su["WA"],
        "dIC": is_["WC"] - su["WC"],
        "dSUA": su["WA"] - sw["WA"],
        "dISA": is_["WA"] - sw["WA"],
        "Wsw": sw["W"],
        "Wsu": su["W"],
        "Wis": is_["W"],
    }


def admissible(v, c, tau, tau_c, eps=1e-10):
    if not (0 <= v < 2 / 7):
        return False
    try:
        q_sw = sw_quantities(c, tau, tau_c)
        q_su = su_quantities(v, c, tau, tau_c)
        q_is = is_quantities(v, tau, tau_c)
    except ZeroDivisionError:
        return False
    for q in (q_sw, q_su, q_is):
        for key in ("x", "y", "z", "w", "t", "QA", "QC"):
            if q[key] <= eps:
                return False
    return True


def equilibrium_regime(v, c, tau, tau_c):
    d = deltas(v, c, tau, tau_c)
    if d["dIC"] >= 0 and d["dIA"] >= 0 and d["dISA"] >= 0:
        return "IS"
    if (d["dIC"] < 0 or d["dIA"] < 0) and d["dSUA"] >= 0:
        return "SU"
    return "SW"


def world_optimal_regime(v, c, tau, tau_c):
    d = deltas(v, c, tau, tau_c)
    values = {"SW": d["Wsw"], "SU": d["Wsu"], "IS": d["Wis"]}
    return max(values, key=values.get)


def add_regime_colorbar(fig, ax, mappable):
    colorbar = fig.colorbar(mappable, ax=ax, ticks=[0, 1, 2], fraction=0.046, pad=0.04)
    colorbar.ax.set_yticklabels(["SW", "SU", "IS"])
    return colorbar


def figure_regime_schematic(out_path):
    fig, axes = plt.subplots(1, 3, figsize=(12, 3.8))
    regimes = ["SW", "SU", "IS"]
    subtitles = {
        "SW": "No mutual recognition",
        "SU": "A and B form a bloc; C remains outside",
        "IS": "All countries share a common standard",
    }
    coords = {"A": (0.25, 0.62), "B": (0.75, 0.62), "C": (0.50, 0.20)}

    for ax, regime in zip(axes, regimes):
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)
        ax.axis("off")
        ax.add_patch(
            FancyBboxPatch(
                (0.02, 0.02),
                0.96,
                0.96,
                boxstyle="round,pad=0.02",
                edgecolor="0.7",
                facecolor="white",
                linewidth=1.2,
            )
        )

        if regime == "SU":
            ax.add_line(Line2D([coords["A"][0], coords["B"][0]], [coords["A"][1], coords["B"][1]], linewidth=4, color="#1f77b4"))
        elif regime == "IS":
            for left, right in [("A", "B"), ("A", "C"), ("B", "C")]:
                ax.add_line(
                    Line2D(
                        [coords[left][0], coords[right][0]],
                        [coords[left][1], coords[right][1]],
                        linewidth=4,
                        color="#1f77b4",
                    )
                )

        for country, (x_pos, y_pos) in coords.items():
            if regime == "SW":
                facecolor = "#f8f8f8"
            elif regime == "SU":
                facecolor = "#dceeff" if country in ("A", "B") else "#fde0dd"
            else:
                facecolor = "#dceeff"
            ax.add_patch(Circle((x_pos, y_pos), 0.09, facecolor=facecolor, edgecolor="0.25", linewidth=1.5))
            ax.text(x_pos, y_pos, country, ha="center", va="center", fontsize=14, fontweight="bold")

        if regime == "SW":
            note = "Foreign cost: c + tau_i"
        elif regime == "SU":
            note = "Within bloc: tau_i\nOutside bloc: c + tau_i"
        else:
            note = "All foreign sales: tau_i"

        ax.text(0.5, 0.90, regime, ha="center", va="center", fontsize=16, fontweight="bold")
        ax.text(0.5, 0.82, subtitles[regime], ha="center", va="center", fontsize=9)
        ax.text(0.5, 0.04, note, ha="center", va="bottom", fontsize=9)

    fig.tight_layout()
    fig.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def figure_regime_map(v, c, tau_max, tau_c_max, out_path, n_tau=300, n_tau_c=300):
    taus = np.linspace(0, tau_max, n_tau)
    tau_cs = np.linspace(0, tau_c_max, n_tau_c)
    z_values = np.full((len(tau_cs), len(taus)), np.nan)

    for row, tau_c in enumerate(tau_cs):
        for col, tau in enumerate(taus):
            if admissible(v, c, tau, tau_c):
                z_values[row, col] = REGIME_TO_CODE[equilibrium_regime(v, c, tau, tau_c)]

    fig, ax = plt.subplots(figsize=(6.4, 5.2))
    image = ax.imshow(np.ma.masked_invalid(z_values), origin="lower", extent=[taus[0], taus[-1], tau_cs[0], tau_cs[-1]], aspect="auto", cmap=REGIME_CMAP, norm=REGIME_NORM)
    add_regime_colorbar(fig, ax, image)
    ax.set_xlabel(r"$\tau$")
    ax.set_ylabel(r"$\tau_C$")
    ax.set_title(f"Equilibrium regime map (v={v:.2f}, c={c:.2f})")
    fig.tight_layout()
    fig.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def figure_divergence_map(v, c, tau_max, tau_c_max, out_path, benchmark_point=None, n_tau=350, n_tau_c=350):
    taus = np.linspace(0, tau_max, n_tau)
    tau_cs = np.linspace(0, tau_c_max, n_tau_c)
    z_values = np.full((len(tau_cs), len(taus)), np.nan)

    for row, tau_c in enumerate(tau_cs):
        for col, tau in enumerate(taus):
            if admissible(v, c, tau, tau_c):
                eq_regime = equilibrium_regime(v, c, tau, tau_c)
                opt_regime = world_optimal_regime(v, c, tau, tau_c)
                z_values[row, col] = 1 if (eq_regime == "SU" and opt_regime == "IS") else 0

    fig, ax = plt.subplots(figsize=(6.4, 5.2))
    cmap = ListedColormap(["white", "#b2182b"])
    image = ax.imshow(np.ma.masked_invalid(z_values), origin="lower", extent=[taus[0], taus[-1], tau_cs[0], tau_cs[-1]], aspect="auto", cmap=cmap, vmin=0, vmax=1)
    colorbar = fig.colorbar(image, ax=ax, ticks=[0, 1], fraction=0.046, pad=0.04)
    colorbar.ax.set_yticklabels(["No divergence", "Eq = SU, world-opt = IS"])
    ax.set_xlabel(r"$\tau$")
    ax.set_ylabel(r"$\tau_C$")
    ax.set_title(f"Divergence region (v={v:.2f}, c={c:.2f})")
    if benchmark_point is not None:
        ax.scatter([benchmark_point[0]], [benchmark_point[1]], color="black", s=25, zorder=3)
    fig.tight_layout()
    fig.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def figure_investment_map(v, c, tau_bar, tau_c_bar, mu, out_path, n_i_h=220, n_i_c=260):
    i_h_values = np.linspace(0, tau_bar / mu, n_i_h)
    i_c_values = np.linspace(0, tau_c_bar / mu, n_i_c)
    z_values = np.full((len(i_c_values), len(i_h_values)), np.nan)

    for row, i_c in enumerate(i_c_values):
        for col, i_h in enumerate(i_h_values):
            tau = tau_bar - mu * i_h
            tau_c = tau_c_bar - mu * i_c
            if tau >= 0 and tau_c >= 0 and admissible(v, c, tau, tau_c):
                z_values[row, col] = REGIME_TO_CODE[equilibrium_regime(v, c, tau, tau_c)]

    fig, ax = plt.subplots(figsize=(6.4, 5.2))
    image = ax.imshow(np.ma.masked_invalid(z_values), origin="lower", extent=[i_h_values[0], i_h_values[-1], i_c_values[0], i_c_values[-1]], aspect="auto", cmap=REGIME_CMAP, norm=REGIME_NORM)
    add_regime_colorbar(fig, ax, image)
    ax.set_xlabel(r"$I_H$")
    ax.set_ylabel(r"$I_C$")
    ax.set_title(
        "Policy-space regime map "
        + f"(v={v:.2f}, c={c:.2f}, "
        + rf"$\bar\tau={tau_bar:.2f}$, $\bar\tau_C={tau_c_bar:.2f}$, $\mu={mu:.2f}$)"
    )
    fig.tight_layout()
    fig.savefig(out_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def main():
    figures_dir = os.path.join(PROJECT_ROOT, "figures")
    os.makedirs(figures_dir, exist_ok=True)

    v = 0.05
    c = 0.05
    tau_benchmark = 0.02
    tau_c_benchmark = 0.18

    figure_regime_schematic(os.path.join(figures_dir, "fig1_regime_schematic.png"))
    figure_regime_map(v, c, 0.20, 0.24, os.path.join(figures_dir, "fig2_regime_map.png"))
    figure_divergence_map(
        v,
        c,
        0.20,
        0.24,
        os.path.join(figures_dir, "fig3_divergence_map.png"),
        benchmark_point=(tau_benchmark, tau_c_benchmark),
    )
    figure_investment_map(
        v,
        c,
        tau_bar=0.04,
        tau_c_bar=0.18,
        mu=1.0,
        out_path=os.path.join(figures_dir, "fig4_investment_map.png"),
    )

    print(f"Saved figures in {figures_dir}")


if __name__ == "__main__":
    main()
