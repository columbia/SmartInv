1 pragma solidity ^0.4.16;
2 
3 contract ERC20Interface {
4     function totalSupply() constant returns (uint256 curTotalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract Ownable {
16   address public owner;
17 
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 }
27 
28 contract EasyToken is ERC20Interface, Ownable {
29     // Public variables of the token
30     string public constant name = "EasyToken";
31     string public constant symbol = "ETKN";
32     uint8 public decimals = 4;
33     uint256 public totalSupply = 250000 * 10 ** uint256(decimals);
34     
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Burn(address indexed from, uint256 value);
39 
40     function EasyToken() public {
41         balanceOf[owner] = totalSupply;
42     }
43 
44     function totalSupply() constant returns (uint256 curTotalSupply) {
45         return totalSupply;
46     }
47 
48     function balanceOf(address _owner) constant returns (uint256 balance) {
49         return balanceOf[_owner];
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
53         return allowance[_owner][_spender];
54     }
55 
56     function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
57         require(_to != 0x0);
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60 
61         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
62         balanceOf[_from] -= _value;
63         balanceOf[_to] += _value;
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65 
66         Transfer(_from, _to, _value);
67 
68         return true;
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public returns (bool success)  {
80         return _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);
94         allowance[_from][msg.sender] -= _value;
95         return _transfer(_from, _to, _value);
96     }
97 
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens in your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
108 
109         allowance[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     /**
115      * Destroy tokens
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) onlyOwner public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         balanceOf[msg.sender] -= _value;
124         totalSupply -= _value;
125         Burn(msg.sender, _value);
126         return true;
127     }
128 }