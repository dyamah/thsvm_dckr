from thundersvmScikit import SVC
from sklearn.datasets import load_svmlight_file

def main():
    data_set_path = 'thundersvm/dataset/test_dataset.txt'
    x,y = load_svmlight_file(data_set_path)
    clf = SVC(verbose=True, gamma=0.5, C=100)
    clf.fit(x,y)

    x2,y2=load_svmlight_file(data_set_path)
    y_predict=clf.predict(x2)
    score=clf.score(x2,y2)
    clf.save_to_file('./test_py.model')
    print("test score is ", score)

if __name__ == "__main__":
    main()