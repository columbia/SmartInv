1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;//管理员
5 
6     function owned() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 contract MyToken is owned {
21     /* the rest of the contract as usual */
22     string public name = "学呗(教育链通证)";
23     string public symbol = "ECT";
24     uint8 public decimals = 8;
25     uint256 public totalSupply = 21000000 * 10 ** uint256(decimals);
26 	
27 	bool public drop = true;
28     uint256 public airDrop = 33 * 10 ** uint256(decimals);
29     uint256 public currentDrop;
30     uint256 public totalDrop = 2000000 * 10 ** uint256(decimals);
31     
32     bool public lock = false;
33 	mapping (address => uint256) public frozenNum;
34 	mapping (address => uint256) public frozenEnd;
35     mapping (address => bool) public initialized;
36     mapping (address => uint256) public balances;
37     
38 	event Transfer(address indexed from,address indexed to, uint256 value);
39     event FrozenMyFunds(address target, uint256 frozen, uint256 fronzeEnd);
40     
41     function MyToken(address centralMinter) public {
42         if(centralMinter != 0) owner = centralMinter;
43 		initialized[owner] = true;
44 		balances[owner] = totalSupply;
45 		emit Transfer(0, owner, totalSupply);
46     }
47 
48     function setDrop(bool _open,uint256 _airDrop, uint256 _totalDrop) public onlyOwner {
49         drop = _open;
50         airDrop = _airDrop;
51         totalDrop = _totalDrop;
52     }
53 	
54 	function setLock(bool _lock) public onlyOwner {
55         lock = _lock;
56     }
57 	
58 	function _freezeFunds(address _address, uint256 _freeze, uint256 _freezeEnd) internal {
59         frozenNum[_address] = _freeze;
60 		frozenEnd[_address] = _freezeEnd;
61         emit FrozenMyFunds(_address, _freeze, _freezeEnd);
62     }
63 	
64 	function freezeUserFunds(address _address, uint256 _freeze, uint256 _freezeEnd) public onlyOwner {
65         _freezeFunds(_address, _freeze, _freezeEnd);
66     }
67 	
68 	function freezeMyFunds(uint256 _freeze, uint256 _freezeEnd) public {
69         _freezeFunds(msg.sender, _freeze, _freezeEnd);
70     }
71     
72     function initialize(address _address) internal returns (uint256) {
73 		require (drop);
74         require (balances[owner] >= airDrop);
75         if(currentDrop + airDrop <= totalDrop && !initialized[_address]){
76             initialized[_address] = true;
77             balances[owner] -= airDrop;
78             balances[_address] += airDrop;
79 			currentDrop += airDrop;
80 			emit Transfer(owner, _address, airDrop);
81         }
82 		return balances[_address];
83     }
84 	
85     function balanceOf(address _address) public view returns(uint256){
86         return balances[_address];
87     }
88     
89     function takeEther(uint256 _balance) public payable onlyOwner {
90          owner.transfer(_balance);
91     }
92     
93     function () payable public {
94 		if(msg.value==0){
95 			initialize(msg.sender);
96 		}
97 	}
98     
99     /* Internal transfer, can only be called by this contract */
100     function _transfer(address _from, address _to, uint256 _value) internal {
101 		if(_from != owner){
102 			require (!lock);
103 		}
104 		if(now <= frozenEnd[_from]){
105 			require (balances[_from] - frozenNum[_from] >= _value);
106 		}else{
107 			require (balances[_from] >= _value);
108 		}
109 		require (balances[_to] + _value > balances[_to]);
110 		
111         balances[_from] -= _value;
112         balances[_to] += _value;
113 		emit Transfer(_from, _to, _value);
114     }
115     
116     function transfer(address _to, uint256  _value) public {
117         _transfer(msg.sender, _to, _value);
118     }
119     
120 }