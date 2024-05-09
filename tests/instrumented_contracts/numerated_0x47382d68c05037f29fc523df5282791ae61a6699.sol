1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library ArrayUtil {
4 function IndexOf(uint[] storage values, uint value) internal returns(uint) {
5     uint i = 0;
6     while (values[i] != value) {
7       i++;
8     }
9     return i;
10   }
11 
12   function RemoveByValue(uint[] storage values, uint value) internal {
13     uint i = IndexOf(values, value);
14     RemoveByIndex(values, i);
15   }
16 
17   function RemoveByIndex(uint[] storage values, uint i) internal {
18     while (i<values.length-1) {
19       values[i] = values[i+1];
20       i++;
21     }
22     values.length--;
23   }
24 }
25 
26 contract UbexContract {
27     address public owner = msg.sender;
28     modifier onlyBy(address _account)
29     {
30         require(
31             msg.sender == _account,
32             "Sender not authorized."
33         );
34         _;
35     }
36 
37     struct RequestsIndex {
38         address addr;
39         bool isEntity;
40         uint256 amount;
41         bytes32 hash;
42     }
43 	
44 	event requestAdded(
45         uint indexed _id,
46         address _addr,
47         uint _amount
48     );
49 	
50 	event requestUpdated(
51 		uint indexed _id,
52         address indexed _addr,
53         bytes32 _hash
54     );
55 	
56     // Requests ids
57     mapping(uint256 => RequestsIndex) public requestsIDsIndex;
58 
59     // Queue of open requests
60     uint[] queue;
61 
62     function addRequest(uint id, address addr, uint256 amount) public onlyBy(owner) returns (bool success) {
63 		if (isEntity(id)) {
64 			return false;
65 		}
66 
67 		queue.push(id);
68 
69 		requestsIDsIndex[id] = RequestsIndex({
70 			addr: addr,
71 			amount: amount,
72 			hash: 0,
73 			isEntity: true
74 		});
75 		emit requestAdded(id, addr, amount);
76         return true;
77     }
78 
79     function getQueueSize() public view returns (uint size) {
80         return queue.length;
81     }
82 
83     function getAddrById(uint _id) public view returns (address _addr){
84         return requestsIDsIndex[_id].addr;
85     }
86 
87     function getRequestById(uint256 _id) public view returns(address addr, uint256 amount, bytes32 hash) {
88         RequestsIndex memory a = requestsIDsIndex[_id];
89         return (a.addr, a.amount, a.hash);
90     }
91 
92     function isEntity(uint _id) public view returns (bool isIndeed) {
93         return requestsIDsIndex[_id].isEntity;
94     }
95     
96     function closeRequest(uint _id, bytes32 _hash) public onlyBy(owner) {
97         requestsIDsIndex[_id].hash = _hash;
98         ArrayUtil.RemoveByValue(queue, _id);
99 		emit requestUpdated(_id, requestsIDsIndex[_id].addr, _hash);
100     }
101 }