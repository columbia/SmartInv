1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
4 
5 contract owned {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 contract Token {
23     function totalSupply() public constant returns (uint256 supply);
24 
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26 
27     function transferTo(address _to, uint256 _value) public returns (bool);
28 
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
30 
31     function approve(address _spender, uint256 _value) public returns (bool success);
32 
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36 
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract StdToken is Token {
41     mapping(address => uint256) balances;
42     mapping(address => mapping(address => uint256)) allowed;
43     uint public supply;
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balances[_from] >= _value);
48         require(balances[_to] + _value >= balances[_to]);
49         uint previousBalances = balances[_from] + balances[_to];
50         balances[_from] -= _value;
51         balances[_to] += _value;
52         emit Transfer(_from, _to, _value);
53         assert(balances[_from] + balances[_to] == previousBalances);
54     }
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         _transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     function transferTo(address _to, uint256 _value) public returns (bool) {
62         _transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function totalSupply() public constant returns (uint256) {
72         return supply;
73     }
74 
75     function balanceOf(address _owner) public constant returns (uint256) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) public returns (bool) {
80         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
81 
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84 
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) public constant returns (uint256) {
89         return allowed[_owner][_spender];
90     }
91 }
92 
93 contract UTC is owned, StdToken {
94 
95     string public name = "UTK Holdings";
96     string public symbol = "UTC";
97     string public website = "www.utk.holdings";
98     uint public decimals = 18;
99 
100     uint256 public totalSupplied;
101 
102     constructor(uint256 _totalSupply) public {
103         supply = _totalSupply * (1 ether / 1 wei);
104         totalSupplied = 0;
105         balances[address(this)] = supply;
106     }
107 
108     function transferTo(address _to, uint256 _value) public onlyOwner returns (bool) {
109         totalSupplied += _value;
110         _transfer(address(this), _to, _value);
111         return true;
112     }
113 }