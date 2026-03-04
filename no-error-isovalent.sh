helm upgrade jobs-app . --namespace tenant-jobs --reuse-values --set crawler.replicas=1 --set crawler.crawlFrequencyLowerBound=0.2 --set crawler.crawlFrequencyUpperBound=5 --set resumes.replicas=20
