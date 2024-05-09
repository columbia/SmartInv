1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract SafeMath {
6   function safeMul(uint256 a, uint256 b) returns (uint256) {
7     uint256 c = a * b;
8     require(a == 0 || c / a == b);
9     return c;
10   }
11   function safeSub(uint256 a, uint256 b) returns (uint256) {
12     require(b <= a);
13     return a - b;
14   }
15   function safeAdd(uint256 a, uint256 b) returns (uint256) {
16     uint c = a + b;
17     require(c >= a && c >= b);
18     return c;
19   }
20 }
21 
22 contract Owned {
23   address public owner;
24   function Owned() {
25     owner = msg.sender;
26   }
27   function setOwner(address _owner) returns (bool success) {
28     owner = _owner;
29     return true;
30   }
31   modifier onlyOwner {
32     require(msg.sender == owner);
33     _;
34   }
35 }
36 
37 contract AURA is SafeMath, Owned {
38     bool public locked = true;
39     string public name = "Aurora DAO";
40     string public symbol = "AURA";
41     uint8 public decimals = 18;
42     uint256 public totalSupply;
43     mapping (address => uint256) public balanceOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * Constructor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function AURA() public {
54         totalSupply = 1000000000000000000000000000;
55         balanceOf[msg.sender] = totalSupply;
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         require(!locked || msg.sender == owner);
63         require(_to != 0x0);
64         require(balanceOf[_from] >= _value);
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         balanceOf[_from] -= _value;
68         balanceOf[_to] += _value;
69         Transfer(_from, _to, _value);
70         require(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     /**
74      * Transfer tokens
75      *
76      * Send `_value` tokens to `_to` from your account
77      *
78      * @param _to The address of the recipient
79      * @param _value the amount to send
80      */
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         _transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87      * Transfer tokens from other address
88      *
89      * Send `_value` tokens to `_to` in behalf of `_from`
90      *
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
96         require(_value <= allowance[_from][msg.sender]);     // Check allowance
97         allowance[_from][msg.sender] -= _value;
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * Set allowance for other address
104      *
105      * Allows `_spender` to spend no more than `_value` tokens in your behalf
106      *
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      */
110     function approve(address _spender, uint256 _value) public
111         returns (bool success) {
112         require(!locked);
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address and notify
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      * @param _extraData some extra information to send to the approved contract
125      */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
127         public
128         returns (bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     function unlockToken() onlyOwner {
137       locked = false;
138     }
139 
140     bool public balancesUploaded = false;
141     function uploadBalances(address[] recipients, uint256[] balances) onlyOwner {
142       require(!balancesUploaded);
143       uint256 sum = 0;
144       for (uint256 i = 0; i < recipients.length; i++) {
145         balanceOf[recipients[i]] = safeAdd(balanceOf[recipients[i]], balances[i]);
146         sum = safeAdd(sum, balances[i]);
147       }
148       balanceOf[owner] = safeSub(balanceOf[owner], sum);
149     }
150     function lockBalances() onlyOwner {
151       balancesUploaded = true;
152     }
153 }