import numpy as np
from sklearn.ensemble import RandomForestClassifier
import sys
try: import cPickle as pickle   # python2
except: import pickle           # python3
from scipy import sparse
from numpy import loadtxt


if len(sys.argv) != 4:
    sys.stderr.write('Arguments error. Usage:\n')
    sys.stderr.write('\tpython train_model.py INPUT_MATRIX_FILE SEED OUTPUT_MODEL_FILE\n')
    sys.exit(1)

input = sys.argv[1]
seed = int(sys.argv[2])
output = sys.argv[3]


lines = loadtxt(input, delimiter=" ", unpack=False,skiprows=2)
matrix=sparse.coo_matrix((lines[:,2],(lines[:,0],lines[:,1])))
matrix2 = matrix.tocsr()

labels = matrix2[:, 1].toarray()
x = matrix2[:, 2:]


sys.stderr.write('Input matrix size {}\n'.format(matrix.shape))
sys.stderr.write('X matrix size {}\n'.format(x.shape))
sys.stderr.write('Y matrix size {}\n'.format(labels.shape))

clf = RandomForestClassifier(n_estimators=500, n_jobs=2, random_state=seed)
clf.fit(x, labels)

with open(output, 'wb') as fd:
    pickle.dump(clf, fd)
