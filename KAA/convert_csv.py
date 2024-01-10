from pathlib import Path
import numpy as np
import pandas as pd

here = Path('./')
augs = ["NA", "R1", "M1"]
locs = ["middle", "topright", "bottomright", "bottomleft", "topleft"]

for aug in augs:
    for loc in locs:
        fname = f'Dong1_{aug}_{loc}'
        np.savetxt(here / (fname + '.csv'), np.load(here / (fname + '.npy')), delimiter=",")
