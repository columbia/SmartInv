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
27     function approve(address _spender, uint256 _value) public returns (bool success);
28 
29     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32 
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35     event Burn(address indexed _burner, uint256 _value);
36 }
37 
38 contract StdToken is Token {
39     mapping(address => uint256) balances;
40     mapping(address => mapping(address => uint256)) allowed;
41     uint public supply;
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balances[_from] >= _value);
46         require(balances[_to] + _value >= balances[_to]);
47         uint previousBalances = balances[_from] + balances[_to];
48         balances[_from] -= _value;
49         balances[_to] += _value;
50         emit Transfer(_from, _to, _value);
51         assert(balances[_from] + balances[_to] == previousBalances);
52     }
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         _transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function totalSupply() public constant returns (uint256) {
60         return supply;
61     }
62 
63     function balanceOf(address _owner) public constant returns (uint256) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) public returns (bool) {
68         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
69 
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72 
73         return true;
74     }
75 
76     function _burn(address _burner, uint256 _value) public returns (bool) {
77         require(_value > 0);
78         require(balances[_burner] > 0);
79         balances[_burner] -= _value;
80         supply -= _value;
81         emit Burn(_burner, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) public constant returns (uint256) {
86         return allowed[_owner][_spender];
87     }
88 }
89 
90 contract RVG is owned, StdToken {
91 
92     string public name = "Revolution Global";
93     string public symbol = "RVG";
94     string public website = "www.rvgtoken.io";
95     uint public decimals = 18;
96 
97     uint256 public totalSupplied;
98     uint256 public totalBurned;
99 
100     struct Holder {
101         address _holderAddress;
102         uint256 _holderAmount;
103     }
104 
105     constructor(uint256 _totalSupply) public {
106         supply = _totalSupply * (1 ether / 1 wei);
107         totalBurned = 0;
108         totalSupplied = 0;
109         balances[address(this)] = supply;
110     }
111 
112     function transfer(address _to, uint256 _value) public onlyOwner returns (bool){
113         totalSupplied += _value;
114         _transfer(address(this), _to, _value);
115         return true;
116     }
117 
118     function burn() public onlyOwner returns (bool){
119         uint256 remainBalance = supply - totalSupplied;
120         uint256 burnAmount = remainBalance / 10;
121         totalBurned += burnAmount;
122         _burn(address(this), burnAmount);
123         return true;
124     }
125 }