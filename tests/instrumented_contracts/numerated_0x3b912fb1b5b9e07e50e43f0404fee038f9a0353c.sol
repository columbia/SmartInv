1 pragma solidity ^0.4.4;
2 
3 contract CountryCoin {
4 
5     string public constant name = "CountryCoin";
6     string public constant symbol = "CCN";
7     uint public constant decimals = 8;
8     uint public totalSupply;
9 
10     mapping (address => uint) balances;
11     mapping (address => mapping (address => uint)) allowed;
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     event Approval(address indexed _owner, address indexed _spender, uint _value);
14 
15     uint constant oneCent = 4642857142857;
16     mapping (uint16 => uint) rating;
17     mapping (uint16 => mapping( address => uint)) votes;
18     mapping (address => uint16[]) history;
19 
20     address owner;
21 
22     function CountryCoin() {
23         totalSupply = 750000000000000000;
24         balances[this] = totalSupply;
25         owner = msg.sender;
26     }
27 
28     function balanceOf(address _owner) constant returns (uint balance) {
29         return balances[_owner];
30     }
31 
32     function transfer(address _to, uint _value) returns (bool success) {
33         require(balances[msg.sender] >= _value);
34         require(balances[_to] + _value > balances[_to]);
35         balances[msg.sender] -= _value;
36         balances[_to] += _value;
37         Transfer(msg.sender, _to, _value);
38         return true;
39     }
40 
41     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
42         require(balances[msg.sender] >= _value);
43         require(allowed[_from][_to] >= _value);
44         require(balances[_to] + _value > balances[_to]);
45 
46         balances[_from] -= _value;
47         balances[_to] += _value;
48         allowed[_from][_to] -= _value;
49 
50         Transfer(_from, _to, _value);
51 
52         return true;
53     }
54 
55     function approve(address _spender, uint _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint remaining) {
62         return allowed[_owner][_spender];
63     }
64 
65     function () payable {
66         uint tokenAmount = msg.value*100000000 / oneCent;
67         require(tokenAmount <= balances[this]);
68 
69         balances[this] -= tokenAmount;
70         balances[msg.sender] += tokenAmount;
71     }
72 
73     function vote(uint16 _country, uint _amount) {
74         require(balances[msg.sender] >= _amount);
75         require(_country < 1000);
76 
77         if (votes[_country][msg.sender] == 0) {
78             history[msg.sender].push(_country);
79         }
80         balances[msg.sender] -= _amount;
81         rating[_country] += _amount;
82         votes[_country][msg.sender] += _amount;
83     }
84 
85     function reset() {
86         for(uint16 i=0; i<history[msg.sender].length; i++) {
87             uint16 country = history[msg.sender][i];
88             uint amount = votes[country][msg.sender];
89             balances[msg.sender] += amount;
90             rating[country] -= amount;
91             votes[country][msg.sender] = 0;
92         }
93         history[msg.sender].length = 0;
94     }
95 
96     function ratingOf(uint16 _country) constant returns (uint) {
97         require(_country < 1000);
98         return rating[_country];
99     }
100 
101     function ratingList() constant returns (uint[] memory r) {
102         r = new uint[](1000);
103         for(uint16 i=0; i<r.length; i++) {
104             r[i] = rating[i];
105         }
106     }
107 
108     function withdraw() {
109         require(msg.sender == owner);
110         owner.transfer(this.balance);
111     }
112 
113 }