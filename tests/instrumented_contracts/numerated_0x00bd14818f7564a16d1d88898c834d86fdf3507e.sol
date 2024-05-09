1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33 
34     function owned() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         owner = newOwner;
45     }
46 }
47 
48 contract frozen is owned {
49 
50     mapping (address => bool) public frozenAccount;
51     event FrozenFunds(address target, bool frozen);
52     
53     modifier isFrozen(address _target) {
54         require(!frozenAccount[_target]);
55         _;
56     }
57 
58     function freezeAccount(address _target, bool _freeze) public onlyOwner {
59         frozenAccount[_target] = _freeze;
60         emit FrozenFunds(_target, _freeze);
61     }
62 }
63 
64 contract XYCCTEST is frozen{
65     
66     using SafeMath for uint256;
67     
68     string public name;
69     string public symbol;
70     uint8 public decimals = 8;  
71     uint256 public totalSupply;
72     uint256 public lockPercent = 95;
73     
74     mapping (address => uint256) public balanceOf;
75     
76     mapping(address => uint256) freezeBalance;
77     mapping(address => uint256) public preTotalTokens;
78 
79     
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     function XYCCTEST() public {
83         totalSupply = 1000000000 * 10 ** uint256(decimals);  
84         balanceOf[msg.sender] = totalSupply;                
85         name = "llltest";                                   
86         symbol = "lllt";                               
87     }
88 
89     function _transfer(address _from, address _to, uint _value) internal isFrozen(_from) isFrozen(_to){
90         require(_to != 0x0);
91         require(balanceOf[_from] >= _value);
92         require(balanceOf[_to].add(_value) > balanceOf[_to]);
93         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
94         if(freezeBalance[_from] > 0){
95             freezeBalance[_from] = preTotalTokens[_from].mul(lockPercent).div(100);
96             require (_value <= balanceOf[_from].sub(freezeBalance[_from])); 
97         }
98         balanceOf[_from] = balanceOf[_from].sub(_value);
99         balanceOf[_to] = balanceOf[_to].add(_value);
100         emit Transfer(_from, _to, _value);
101         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool){
105         _transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     
110     function lock(address _to, uint256 _value) public onlyOwner isFrozen(_to){
111         _value = _value.mul(10 ** uint256(decimals));
112 		require(balanceOf[owner] >= _value);
113 		require (balanceOf[_to].add(_value)> balanceOf[_to]); 
114 		require (_to != 0x0);
115 		uint previousBalances = balanceOf[owner].add(balanceOf[_to]);
116         balanceOf[owner] = balanceOf[owner].sub(_value);
117         balanceOf[ _to] =balanceOf[_to].add(_value);
118         preTotalTokens[_to] = preTotalTokens[_to].add(_value);
119         freezeBalance[_to] = preTotalTokens[_to].mul(lockPercent).div(100);
120 	    emit Transfer(owner, _to, _value);
121 	    assert(balanceOf[owner].add(balanceOf[_to]) == previousBalances);
122     }
123     
124     function updataLockPercent() external onlyOwner {
125         require(lockPercent > 0);
126         lockPercent = lockPercent.sub(5);
127     }
128 
129 }