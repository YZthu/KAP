from pathlib import Path
map = {
        "NA": "B1",
        "R1": "B2",
        "M1": "B3",
        }

here = Path("./")
assert here != None, "not none"
for p in here.iterdir():
    if p.suffix == "": p.rename(p.parent / (p.stem + ".mat"))
    if p.suffix != ".mat": continue
    print(p.suffix)
    pname = p.stem.split("_")
    pname[1] = map[pname[1]]
    p.rename(p.parent / ("_".join(pname) + ".mat"))

