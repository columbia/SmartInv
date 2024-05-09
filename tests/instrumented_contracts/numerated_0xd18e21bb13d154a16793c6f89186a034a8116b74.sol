1 contract ZeroDollarHomePage {
2     event InvalidPullRequest(uint indexed pullRequestId);
3     event PullRequestAlreadyClaimed(uint indexed pullRequestId, uint timeBeforeDisplay, bool past);
4     event PullRequestClaimed(uint indexed pullRequestId, uint timeBeforeDisplay);
5     event QueueIsEmpty();
6 
7     bool _handledFirst;
8     uint[] _queue;
9     uint _current;
10     address owner;
11 
12     function ZeroDollarHomePage() {
13         owner = msg.sender;
14         _handledFirst = false;
15         _current = 0;
16     }
17 
18     function remove() {
19         if (msg.sender == owner){
20             suicide(owner);
21         }
22     }
23 
24     /*
25      * Register a new pull request.
26      */
27     function newRequest(uint pullRequestId) {
28         if (pullRequestId <= 0) {
29             InvalidPullRequest(pullRequestId);
30             return;
31         }
32 
33         // Check that the pr hasn't already been claimed
34         bool found = false;
35         uint index = 0;
36 
37         while (!found && index < _queue.length) {
38             if (_queue[index] == pullRequestId) {
39                 found = true;
40                 break;
41             } else {
42                 index++;
43             }
44         }
45 
46         if (found) {
47             PullRequestAlreadyClaimed(pullRequestId, (index - _current) * 1 days, _current > index);
48             return;
49         }
50 
51         _queue.push(pullRequestId);
52         PullRequestClaimed(pullRequestId, (_queue.length - _current) * 1 days);
53     }
54 
55     /*
56      * Close the current request in queue and move the queue to its next element.
57      */
58     function closeRequest() {
59         if (_handledFirst && _current < _queue.length - 1) {
60             _current += 1;
61         }
62 
63         _handledFirst = true;
64     }
65 
66     /*
67      * Get the last non published pull-request from the queue
68      */
69     function getLastNonPublished() constant returns (uint pullRequestId) {
70         if (_current >= _queue.length) {
71             return 0;
72         }
73 
74         return _queue[_current];
75     }
76 }