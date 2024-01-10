import numpy as np
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

def plot_tsne(X, y):
    # Perform t-SNE dimensionality reduction
    tsne = TSNE(n_components=2, random_state=42)
    X_embedded = tsne.fit_transform(X)

    # Plotting
    plt.figure(figsize=(8, 6))
    classes = np.unique(y)
    for class_label in classes:
        plt.scatter(X_embedded[y == class_label, 0], X_embedded[y == class_label, 1], label=str(class_label))
    plt.title('t-SNE Visualization')
    plt.xlabel('Dimension 1')
    plt.ylabel('Dimension 2')
    plt.legend()
    plt.show()

# Example usage
# Replace X and y with your feature set and corresponding labels
# Assuming X is your feature set (numpy array or pandas DataFrame) and y is the labels (numpy array or list)
# Replace these lines with your data
X = np.random.rand(100, 10)  # Example feature set with 100 samples and 10 features
y = np.random.randint(0, 3, 100)  # Example labels (assuming 3 classes)

plot_tsne(X, y)