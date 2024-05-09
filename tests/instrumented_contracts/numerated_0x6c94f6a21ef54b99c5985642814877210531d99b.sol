1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 supply) {}
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8     function approve(address _spender, uint256 _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15     function transfer(address _to, uint256 _value) returns (bool success) {
16         if (balances[msg.sender] >= _value && _value > 0) {
17             balances[msg.sender] -= _value;
18             balances[_to] += _value;
19             Transfer(msg.sender, _to, _value);
20             return true;
21         } else { return false; }
22     }
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32     function balanceOf(address _owner) constant returns (uint256 balance) {
33         return balances[_owner];
34     }
35 
36     function approve(address _spender, uint256 _value) returns (bool success) {
37         allowed[msg.sender][_spender] = _value;
38         Approval(msg.sender, _spender, _value);
39         return true;
40     }
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
42       return allowed[_owner][_spender];
43     }
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     uint256 public totalSupply;
47 }
48 
49 
50 contract Fouracoin is StandardToken {
51     //Verify tokenname is ERC20Token
52     //http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.13+commit.fb4cb1a.js
53     string public name;                   //fancy name: eg Simon Bucks
54     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
55     string public symbol;                 //An identifier: eg SBX
56     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
57     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
58     address public fundsWallet;           // Where should the raised ETH go?
59 
60 
61     function Fouracoin() {
62         balances[msg.sender] = 300000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
63         totalSupply = 300000000000000000000000000;                        // Update total supply (100000 for example)
64         name = "4A Coin";                                   // Set the name for display purposes
65         decimals = 18;                            // Amount of decimals for display purposes
66         symbol = "4AC";
67         //unitsOneEthCanBuy = 6000;                                // Set the symbol for display purposes
68         fundsWallet = msg.sender;
69     }
70 
71     function() payable{
72 
73       uint256 ondortmayis = 1526256000;
74       uint256 yirmibirmay = 1526860800;
75       uint256 yirmisekizmay = 1527465600;
76       uint256 dorthaziran = 1528070400;
77       uint256 onbirhaziran = 1528675200;
78       uint256 onsekizhaziran = 1529280000;
79       uint256 yirmibeshaz = 1529884800;
80 
81       if(ondortmayis > now) {
82         require(balances[fundsWallet] >= msg.value * 100);
83         balances[fundsWallet] = balances[fundsWallet] - msg.value * 100;
84         balances[msg.sender] = balances[msg.sender] + msg.value * 100;
85         Transfer(fundsWallet, msg.sender, msg.value * 100); // Broadcast a message to the blockchain
86         fundsWallet.transfer(msg.value);
87       } else if(ondortmayis < now && yirmibirmay > now) {
88         require(balances[fundsWallet] >= msg.value * 6000);
89         balances[fundsWallet] = balances[fundsWallet] - msg.value * 6000;
90         balances[msg.sender] = balances[msg.sender] + msg.value * 6000;
91         Transfer(fundsWallet, msg.sender, msg.value * 6000); // Broadcast a message to the blockchain
92         fundsWallet.transfer(msg.value);
93       } else if(yirmibirmay < now && yirmisekizmay > now) {
94         require(balances[fundsWallet] >= msg.value * 4615);
95         balances[fundsWallet] = balances[fundsWallet] - msg.value * 4615;
96         balances[msg.sender] = balances[msg.sender] + msg.value * 4615;
97         Transfer(fundsWallet, msg.sender, msg.value * 4615); // Broadcast a message to the blockchain
98         fundsWallet.transfer(msg.value);
99       }else if(yirmisekizmay < now && dorthaziran > now) {
100         require(balances[fundsWallet] >= msg.value * 3750);
101         balances[fundsWallet] = balances[fundsWallet] - msg.value * 3750;
102         balances[msg.sender] = balances[msg.sender] + msg.value * 3750;
103         Transfer(fundsWallet, msg.sender, msg.value * 3750); // Broadcast a message to the blockchain
104         fundsWallet.transfer(msg.value);
105       }else if(dorthaziran < now && onbirhaziran > now) {
106         require(balances[fundsWallet] >= msg.value * 3157);
107         balances[fundsWallet] = balances[fundsWallet] - msg.value * 3157;
108         balances[msg.sender] = balances[msg.sender] + msg.value * 3157;
109         Transfer(fundsWallet, msg.sender, msg.value * 3157); // Broadcast a message to the blockchain
110         fundsWallet.transfer(msg.value);
111       }else if(onbirhaziran < now && onsekizhaziran > now) {
112         require(balances[fundsWallet] >= msg.value * 2727);
113         balances[fundsWallet] = balances[fundsWallet] - msg.value * 2727;
114         balances[msg.sender] = balances[msg.sender] + msg.value * 2727;
115         Transfer(fundsWallet, msg.sender, msg.value * 2727); // Broadcast a message to the blockchain
116         fundsWallet.transfer(msg.value);
117       }else if(onsekizhaziran < now && yirmibeshaz > now) {
118         require(balances[fundsWallet] >= msg.value * 2400);
119         balances[fundsWallet] = balances[fundsWallet] - msg.value * 2400;
120         balances[msg.sender] = balances[msg.sender] + msg.value * 2400;
121         Transfer(fundsWallet, msg.sender, msg.value * 2400); // Broadcast a message to the blockchain
122         fundsWallet.transfer(msg.value);
123       }
124       else {
125         throw;
126       }
127     }
128 
129 
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }