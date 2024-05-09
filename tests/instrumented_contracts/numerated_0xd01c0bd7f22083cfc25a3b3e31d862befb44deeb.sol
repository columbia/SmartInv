1 // Eth Heap
2 // Author: Zac Mitton
3 // License: Use for all the things. And make lots of money with it.
4 
5 pragma solidity 0.4.24;
6 
7 library Heap{ // default max-heap
8 
9   uint constant ROOT_INDEX = 1;
10 
11   struct Data{
12     int128 idCount;
13     Node[] nodes; // root is index 1; index 0 not used
14     mapping (int128 => uint) indices; // unique id => node index
15   }
16   struct Node{
17     int128 id; //use with another mapping to store arbitrary object types
18     int128 priority;
19   }
20 
21   //call init before anything else
22   function init(Data storage self) internal{
23     if(self.nodes.length == 0) self.nodes.push(Node(0,0));
24   }
25 
26   function insert(Data storage self, int128 priority) internal returns(Node){//√
27     if(self.nodes.length == 0){ init(self); }// test on-the-fly-init
28     self.idCount++;
29     self.nodes.length++;
30     Node memory n = Node(self.idCount, priority);
31     _bubbleUp(self, n, self.nodes.length-1);
32     return n;
33   }
34   function extractMax(Data storage self) internal returns(Node){//√
35     return _extract(self, ROOT_INDEX);
36   }
37   function extractById(Data storage self, int128 id) internal returns(Node){//√
38     return _extract(self, self.indices[id]);
39   }
40 
41   //view
42   function dump(Data storage self) internal view returns(Node[]){
43   //note: Empty set will return `[Node(0,0)]`. uninitialized will return `[]`.
44     return self.nodes;
45   }
46   function getById(Data storage self, int128 id) internal view returns(Node){
47     return getByIndex(self, self.indices[id]);//test that all these return the emptyNode
48   }
49   function getByIndex(Data storage self, uint i) internal view returns(Node){
50     return self.nodes.length > i ? self.nodes[i] : Node(0,0);
51   }
52   function getMax(Data storage self) internal view returns(Node){
53     return getByIndex(self, ROOT_INDEX);
54   }
55   function size(Data storage self) internal view returns(uint){
56     return self.nodes.length > 0 ? self.nodes.length-1 : 0;
57   }
58   function isNode(Node n) internal pure returns(bool){ return n.id > 0; }
59 
60   //private
61   function _extract(Data storage self, uint i) private returns(Node){//√
62     if(self.nodes.length <= i || i <= 0){ return Node(0,0); }
63 
64     Node memory extractedNode = self.nodes[i];
65     delete self.indices[extractedNode.id];
66 
67     Node memory tailNode = self.nodes[self.nodes.length-1];
68     self.nodes.length--;
69 
70     if(i < self.nodes.length){ // if extracted node was not tail
71       _bubbleUp(self, tailNode, i);
72       _bubbleDown(self, self.nodes[i], i); // then try bubbling down
73     }
74     return extractedNode;
75   }
76   function _bubbleUp(Data storage self, Node memory n, uint i) private{//√
77     if(i==ROOT_INDEX || n.priority <= self.nodes[i/2].priority){
78       _insert(self, n, i);
79     }else{
80       _insert(self, self.nodes[i/2], i);
81       _bubbleUp(self, n, i/2);
82     }
83   }
84   function _bubbleDown(Data storage self, Node memory n, uint i) private{//
85     uint length = self.nodes.length;
86     uint cIndex = i*2; // left child index
87 
88     if(length <= cIndex){
89       _insert(self, n, i);
90     }else{
91       Node memory largestChild = self.nodes[cIndex];
92 
93       if(length > cIndex+1 && self.nodes[cIndex+1].priority > largestChild.priority ){
94         largestChild = self.nodes[++cIndex];// TEST ++ gets executed first here
95       }
96 
97       if(largestChild.priority <= n.priority){ //TEST: priority 0 is valid! negative ints work
98         _insert(self, n, i);
99       }else{
100         _insert(self, largestChild, i);
101         _bubbleDown(self, n, cIndex);
102       }
103     }
104   }
105 
106   function _insert(Data storage self, Node memory n, uint i) private{//√
107     self.nodes[i] = n;
108     self.indices[n.id] = i;
109   }
110 }
111 
112 
113 contract BountyHeap{
114   using Heap for Heap.Data;
115   Heap.Data public data;
116 
117   uint public createdAt;
118   address public author;
119 
120   constructor(address _author) public {
121     data.init();
122     createdAt = now;
123     author = _author;
124   }
125 
126   function () public payable{}
127 
128   function endBounty() public{
129     require(now > createdAt + 2592000); //60*60*24*30 = 2592000 = 30 days
130     author.transfer(address(this).balance); //any remaining ETH goes back to me
131   }
132 
133   function breakCompleteness(uint holeIndex, uint filledIndex, address recipient) public{
134     require(holeIndex > 0); // 0 index is empty by design (doesn't count)
135     require(data.getByIndex(holeIndex).id == 0); //holeIndex has nullNode
136     require(data.getByIndex(filledIndex).id != 0); // filledIndex has a node
137     require(holeIndex < filledIndex); //HOLE IN MIDDLE OF HEAP!
138     recipient.transfer(address(this).balance);
139   }
140   function breakParentsHaveGreaterPriority(uint indexChild, address recipient) public{
141     Heap.Node memory child = data.getByIndex(indexChild);
142     Heap.Node memory parent = data.getByIndex(indexChild/2);
143 
144     require(Heap.isNode(child));
145     require(Heap.isNode(parent));
146     require(child.priority > parent.priority); // CHILD PRIORITY LARGER THAN PARENT!
147     recipient.transfer(address(this).balance);
148   }
149   function breakIdMaintenance(int128 id, address recipient) public{
150     require(data.indices[id] != 0); //id exists in mapping
151     require(data.nodes[data.indices[id]].id != id); // BUT NODE HAS CONTRIDICTORY ID!
152     recipient.transfer(address(this).balance);
153   }
154   function breakIdMaintenance2(uint index, address recipient) public{
155     Heap.Node memory n = data.getByIndex(index);
156 
157     require(Heap.isNode(n)); //node exists in array
158     require(index != data.indices[n.id]); // BUT MAPPING DOESNT POINT TO IT!
159     recipient.transfer(address(this).balance);
160   }
161   function breakIdUniqueness(uint index1, uint index2, address recipient) public{
162     Heap.Node memory node1 = data.getByIndex(index1);
163     Heap.Node memory node2 = data.getByIndex(index2);
164 
165     require(Heap.isNode(node1));
166     require(Heap.isNode(node2));
167     require(index1 != index2);     //2 different positions in the heap
168     require(node1.id == node2.id); //HAVE 2 NODES WITH THE SAME ID!
169     recipient.transfer(address(this).balance);
170   }
171 
172   function heapify(int128[] priorities) public {
173     for(uint i ; i < priorities.length ; i++){
174     data.insert(priorities[i]);
175     }
176   }
177   function insert(int128 priority) public returns(int128){
178     return data.insert(priority).id;
179   }
180   function extractMax() public returns(int128){
181     return data.extractMax().priority;
182   }
183   function extractById(int128 id) public returns(int128){
184     return data.extractById(id).priority;
185   }
186   //view
187   // // Unfortunately the function below requires the experimental compiler
188   // // which cant be verified on etherscan or used natively with truffle.
189   // // Hopefully soon it will be standard.
190   // function dump() public view returns(Heap.Node[]){
191   //     return data.dump();
192   // }
193   function getIdMax() public view returns(int128){
194     return data.getMax().id;
195   }
196   function getMax() public view returns(int128){
197     return data.getMax().priority;
198   }
199   function getById(int128 id) public view returns(int128){
200     return data.getById(id).priority;
201   }
202   function getIdByIndex(uint i) public view returns(int128){
203     return data.getByIndex(i).id;
204   }
205   function getByIndex(uint i) public view returns(int128){
206     return data.getByIndex(i).priority;
207   }
208   function size() public view returns(uint){
209     return data.size();
210   }
211   function idCount() public view returns(int128){
212     return data.idCount;
213   }
214   function indices(int128 id) public view returns(uint){
215     return data.indices[id];
216   }
217 }