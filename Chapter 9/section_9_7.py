import nltk.classify.util
from nltk.classify import NaiveBayesClassifier
from nltk.corpus import movie_reviews
from collections import defaultdict
import numpy as np
 
# define a 80/20 split for train/test
SPLIT = 0.8 

# file IDs for the positive and negative reviews
posids = movie_reviews.fileids('pos')
negids = movie_reviews.fileids('neg')

def word_feats(words):
    feats = defaultdict(lambda: False)
    for word in words:
        feats[word] = True
    return feats

posfeats = [(word_feats(movie_reviews.words(fileids=[f])), 'pos') for f in posids]
negfeats = [(word_feats(movie_reviews.words(fileids=[f])), 'neg') for f in negids]

cutoff = int(len(posfeats) * SPLIT)

trainfeats = negfeats[:cutoff] + posfeats[:cutoff]
testfeats = negfeats[cutoff:] + posfeats[cutoff:]

print 'Train on %d instances' % len(trainfeats)
print 'Test on %d instances' % len(testfeats)

classifier = NaiveBayesClassifier.train(trainfeats)
print 'Accuracy:', nltk.classify.util.accuracy(classifier, testfeats)

classifier.show_most_informative_features()

# prepare confusion matrix
pos = np.array([classifier.classify(fs) for (fs,l) in posfeats[cutoff:]])
neg = np.array([classifier.classify(fs) for (fs,l) in negfeats[cutoff:]])
print 'Confusion matrix:'
print '\t'*2, 'Predicted class'
print '-'*40
print '|\t %d (TP) \t|\t %d (FN) \t| Actual class' % (
          (pos == 'pos').sum(), (pos == 'neg').sum())
print '-'*40
print '|\t %d (FP) \t|\t %d (TN) \t|' % (
          (neg == 'pos').sum(), (neg == 'neg').sum())
print '-'*40
