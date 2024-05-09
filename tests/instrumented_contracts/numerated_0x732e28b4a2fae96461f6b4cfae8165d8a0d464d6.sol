1 pragma solidity ^0.4.18;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 contract EIP20Interface {
9     uint256 public totalSupply;
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 contract Owned {
20     address public owner;
21     address public newOwner;
22 
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25     function Owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     function transferOwnership(address _newOwner) public onlyOwner {
35         newOwner = _newOwner;
36     }
37 
38     function acceptOwnership() public {
39         require(msg.sender == newOwner);
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42         newOwner = address(0);
43     }
44 }
45 
46 contract AMLOveCoin is EIP20Interface, Owned{
47     mapping (address => uint256) balances;
48     mapping (address => mapping (address => uint256)) allowed;
49     uint256 public totalContribution = 0;
50     uint februaryLastTime = 1519862399;
51     uint marchLastTime = 1522540799;
52     uint aprilLastTime = 1525132799;
53     uint juneLastTime = 1530403199;
54     modifier onlyExecuteBy(address _account)
55     {
56         require(msg.sender == _account);
57         _;
58     }
59     string public symbol;
60     string public name;
61     uint8 public decimals;
62 
63     function balanceOf(address _owner) public constant returns (uint256) {
64       return balances[_owner];
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         require(msg.data.length >= (2 * 32) + 4);
69         if (_value == 0) { return false; }
70         uint256 fromBalance = balances[msg.sender];
71         bool sufficientFunds = fromBalance >= _value;
72         bool overflowed = balances[_to] + _value < balances[_to];
73         if (sufficientFunds && !overflowed) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(msg.data.length >= (2 * 32) + 4);
83         if (_value == 0) { return false; }
84         uint256 fromBalance = balances[_from];
85         uint256 allowance = allowed[_from][msg.sender];
86         bool sufficientFunds = fromBalance <= _value;
87         bool sufficientAllowance = allowance <= _value;
88         bool overflowed = balances[_to] + _value > balances[_to];
89         if (sufficientFunds && sufficientAllowance && !overflowed) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92             allowed[_from][msg.sender] -= _value;
93             Transfer(_from, _to, _value);
94             return true;
95         } else { return false; }
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public constant returns (uint256) {
106         return allowed[_owner][_spender];
107     }
108 
109     function withdrawForeignTokens(address _tokenContract) public onlyExecuteBy(owner) returns (bool) {
110         ForeignToken token = ForeignToken(_tokenContract);
111         uint256 amount = token.balanceOf(address(this));
112         return token.transfer(owner, amount);
113     }
114 
115     function withdraw() public onlyExecuteBy(owner) {
116         owner.transfer(this.balance);
117     }
118 
119     function getStats() public constant returns (uint256, uint256, bool) {
120         bool purchasingAllowed = (getTime() < juneLastTime);
121         return (totalContribution, totalSupply, purchasingAllowed);
122     }
123 
124     function AMLOveCoin() public {
125         owner = msg.sender;
126         symbol = "AML";
127         name = "AMLOve";
128         decimals = 18;
129         uint256 tokensIssued = 1300000 ether;
130         totalSupply += tokensIssued;
131         balances[msg.sender] += tokensIssued;
132         Transfer(address(this), msg.sender, tokensIssued);
133     }
134 
135     function() payable public {
136         require(msg.value >= 1 finney);
137         uint rightNow = getTime();
138         require(rightNow < juneLastTime);
139         owner.transfer(msg.value);
140         totalContribution += msg.value;
141         uint rate = 10000;
142         if(rightNow < februaryLastTime){
143            rate = 15000;
144         } else {
145            if(rightNow < marchLastTime){
146               rate = 13000;
147            } else {
148               if(rightNow < aprilLastTime){
149                  rate = 11000;
150               }
151            }
152         }
153         uint256 tokensIssued = (msg.value * rate);
154         uint256 futureTokenSupply = (totalSupply + tokensIssued);
155         uint256 maxSupply = 13000000 ether;
156         require(futureTokenSupply < maxSupply);
157         totalSupply += tokensIssued;
158         balances[msg.sender] += tokensIssued;
159         Transfer(address(this), msg.sender, tokensIssued);
160     }
161 
162     function getTime() internal constant returns (uint) {
163       return now;
164     }
165 }