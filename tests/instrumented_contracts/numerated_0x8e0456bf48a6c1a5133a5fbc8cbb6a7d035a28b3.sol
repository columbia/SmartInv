1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4   function transfer(address _to, uint256 _amount) external returns (bool success);
5   function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success);
6   function balanceOf(address _owner) constant external returns (uint256 balance);
7   function approve(address _spender, uint256 _amount) external returns (bool success);
8   function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
9   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) external returns (bool success);
10   function totalSupply() external constant returns (uint);
11 }
12 
13 interface IResultStorage {
14     function getResult(bytes32 _predictionId) external returns (uint8);
15 }
16 
17 contract Owned {
18     address public owner;
19     address public executor;
20     address public superOwner;
21   
22     event OwnershipTransferred(address indexed _from, address indexed _to);
23 
24     constructor() public {
25         superOwner = msg.sender;
26         owner = msg.sender;
27         executor = msg.sender;
28     }
29 
30     modifier onlyOwner {
31         require(msg.sender == owner, "User is not owner");
32         _;
33     }
34 
35     modifier onlySuperOwner {
36         require(msg.sender == superOwner, "User is not owner");
37         _;
38     }
39 
40     modifier onlyOwnerOrSuperOwner {
41         require(msg.sender == owner || msg.sender == superOwner, "User is not owner");
42         _;
43     }
44 
45     modifier onlyAllowed {
46         require(msg.sender == owner || msg.sender == executor || msg.sender == superOwner, "Not allowed");
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwnerOrSuperOwner {
51         owner = _newOwner;
52     }
53 
54     function transferSuperOwnership(address _newOwner) public onlySuperOwner {
55         superOwner = _newOwner;
56     }
57 
58     function transferExecutorOwnership(address _newExecutor) public onlyOwnerOrSuperOwner {
59         emit OwnershipTransferred(executor, _newExecutor);
60         executor = _newExecutor;
61     }
62 }
63 
64 contract ResultStorage is Owned, IResultStorage {
65 
66     event ResultAssigned(bytes32 indexed _predictionId, uint8 _outcomeId);
67     event Withdraw(uint _amount);
68 
69     struct Result {     
70         uint8 outcomeId;
71         bool resolved; 
72     }
73 
74     uint8 public constant version = 1;
75     bool public paused;
76     mapping(bytes32 => Result) public results;  
77 
78     modifier notPaused() {
79         require(paused == false, "Contract is paused");
80         _;
81     }
82 
83     modifier resolved(bytes32 _predictionId) {
84         require(results[_predictionId].resolved == true, "Prediction is not resolved");
85         _;
86     }
87  
88     function setOutcome (bytes32 _predictionId, uint8 _outcomeId)
89             public 
90             onlyAllowed
91             notPaused {        
92         
93         results[_predictionId].outcomeId = _outcomeId;
94         results[_predictionId].resolved = true;
95         
96         emit ResultAssigned(_predictionId, _outcomeId);
97     }
98 
99     function getResult(bytes32 _predictionId) 
100             public 
101             view 
102             resolved(_predictionId)
103             returns (uint8) {
104         return results[_predictionId].outcomeId;
105     }
106 
107     //////////
108     // Safety Methods
109     //////////
110     function () public payable {
111         require(false);
112     }
113 
114     function withdrawETH() external onlyOwnerOrSuperOwner {
115         uint balance = address(this).balance;
116         owner.transfer(balance);
117         emit Withdraw(balance);
118     }
119 
120     function withdrawTokens(uint _amount, address _token) external onlyOwnerOrSuperOwner {
121         assert(IERC20(_token).transfer(owner, _amount));
122         emit Withdraw(_amount);
123     }
124 
125     function pause(bool _paused) external onlyOwnerOrSuperOwner {
126         paused = _paused;
127     }
128 }