1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 /**
5  * @title QueueLib
6  * @author Illusory Systems Inc.
7  * @notice Library containing queue struct and operations for queue used by
8  * Home and Replica.
9  **/
10 library QueueLib {
11     /**
12      * @notice Queue struct
13      * @dev Internally keeps track of the `first` and `last` elements through
14      * indices and a mapping of indices to enqueued elements.
15      **/
16     struct Queue {
17         uint128 first;
18         uint128 last;
19         mapping(uint256 => bytes32) queue;
20     }
21 
22     /**
23      * @notice Initializes the queue
24      * @dev Empty state denoted by _q.first > q._last. Queue initialized
25      * with _q.first = 1 and _q.last = 0.
26      **/
27     function initialize(Queue storage _q) internal {
28         if (_q.first == 0) {
29             _q.first = 1;
30         }
31     }
32 
33     /**
34      * @notice Enqueues a single new element
35      * @param _item New element to be enqueued
36      * @return _last Index of newly enqueued element
37      **/
38     function enqueue(Queue storage _q, bytes32 _item)
39         internal
40         returns (uint128 _last)
41     {
42         _last = _q.last + 1;
43         _q.last = _last;
44         if (_item != bytes32(0)) {
45             // saves gas if we're queueing 0
46             _q.queue[_last] = _item;
47         }
48     }
49 
50     /**
51      * @notice Dequeues element at front of queue
52      * @dev Removes dequeued element from storage
53      * @return _item Dequeued element
54      **/
55     function dequeue(Queue storage _q) internal returns (bytes32 _item) {
56         uint128 _last = _q.last;
57         uint128 _first = _q.first;
58         require(_length(_last, _first) != 0, "Empty");
59         _item = _q.queue[_first];
60         if (_item != bytes32(0)) {
61             // saves gas if we're dequeuing 0
62             delete _q.queue[_first];
63         }
64         _q.first = _first + 1;
65     }
66 
67     /**
68      * @notice Batch enqueues several elements
69      * @param _items Array of elements to be enqueued
70      * @return _last Index of last enqueued element
71      **/
72     function enqueue(Queue storage _q, bytes32[] memory _items)
73         internal
74         returns (uint128 _last)
75     {
76         _last = _q.last;
77         for (uint256 i = 0; i < _items.length; i += 1) {
78             _last += 1;
79             bytes32 _item = _items[i];
80             if (_item != bytes32(0)) {
81                 _q.queue[_last] = _item;
82             }
83         }
84         _q.last = _last;
85     }
86 
87     /**
88      * @notice Batch dequeues `_number` elements
89      * @dev Reverts if `_number` > queue length
90      * @param _number Number of elements to dequeue
91      * @return Array of dequeued elements
92      **/
93     function dequeue(Queue storage _q, uint256 _number)
94         internal
95         returns (bytes32[] memory)
96     {
97         uint128 _last = _q.last;
98         uint128 _first = _q.first;
99         // Cannot underflow unless state is corrupted
100         require(_length(_last, _first) >= _number, "Insufficient");
101 
102         bytes32[] memory _items = new bytes32[](_number);
103 
104         for (uint256 i = 0; i < _number; i++) {
105             _items[i] = _q.queue[_first];
106             delete _q.queue[_first];
107             _first++;
108         }
109         _q.first = _first;
110         return _items;
111     }
112 
113     /**
114      * @notice Returns true if `_item` is in the queue and false if otherwise
115      * @dev Linearly scans from _q.first to _q.last looking for `_item`
116      * @param _item Item being searched for in queue
117      * @return True if `_item` currently exists in queue, false if otherwise
118      **/
119     function contains(Queue storage _q, bytes32 _item)
120         internal
121         view
122         returns (bool)
123     {
124         for (uint256 i = _q.first; i <= _q.last; i++) {
125             if (_q.queue[i] == _item) {
126                 return true;
127             }
128         }
129         return false;
130     }
131 
132     /// @notice Returns last item in queue
133     /// @dev Returns bytes32(0) if queue empty
134     function lastItem(Queue storage _q) internal view returns (bytes32) {
135         return _q.queue[_q.last];
136     }
137 
138     /// @notice Returns element at front of queue without removing element
139     /// @dev Reverts if queue is empty
140     function peek(Queue storage _q) internal view returns (bytes32 _item) {
141         require(!isEmpty(_q), "Empty");
142         _item = _q.queue[_q.first];
143     }
144 
145     /// @notice Returns true if queue is empty and false if otherwise
146     function isEmpty(Queue storage _q) internal view returns (bool) {
147         return _q.last < _q.first;
148     }
149 
150     /// @notice Returns number of elements in queue
151     function length(Queue storage _q) internal view returns (uint256) {
152         uint128 _last = _q.last;
153         uint128 _first = _q.first;
154         // Cannot underflow unless state is corrupted
155         return _length(_last, _first);
156     }
157 
158     /// @notice Returns number of elements between `_last` and `_first` (used internally)
159     function _length(uint128 _last, uint128 _first)
160         internal
161         pure
162         returns (uint256)
163     {
164         return uint256(_last + 1 - _first);
165     }
166 }
