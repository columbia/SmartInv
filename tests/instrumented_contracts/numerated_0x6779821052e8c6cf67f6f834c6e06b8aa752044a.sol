1 pragma solidity ^0.4.18;
2 /**
3  * This smart contract code is Copyright 2022 EthereumRenew. For more information see https://ethereumrenew.org
4  *
5  * Licensed under the Apache License, version 2.0
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that revert() on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically revert()s when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 
42 /*
43  * ETHREN
44  *
45  * Abstract contract that create ETHREN Token based on ERC20.
46  *
47  */
48 contract ETHREN {
49     using SafeMath for uint256;
50     string public name;
51     string public symbol;
52     uint8 public decimals;
53     uint256 public totalSupply;
54     address public owner;
55 
56     /* This creates an array with all balances */
57     mapping (address => uint256) public balanceOf;
58     mapping (address => uint256) public freezeOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     /* This generates a public event on the blockchain that will notify clients */
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     /* This notifies clients about the amount burnt */
65     event Burn(address indexed from, uint256 value);
66 
67     /* This notifies clients about the amount frozen */
68     event Freeze(address indexed from, uint256 value);
69 
70     /* This notifies clients about the amount unfrozen */
71     event Unfreeze(address indexed from, uint256 value);
72 
73     /* This notifies the owner transfer */
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /* Initializes contract with initial supply tokens to the creator of the contract */
77     function ETHREN( uint256 initialSupply, uint8 decimalUnits) public {
78         balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
79         totalSupply = initialSupply; // Update total supply
80         name = "Ethereum Renew";   // Set the name for display purposes
81         symbol = "ETHREN";    // Set the symbol for display purposes
82         decimals = decimalUnits;  // Amount of decimals for display purposes
83         owner = msg.sender;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90       require(msg.sender == owner);
91       _;
92     }
93 
94     /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99       require(newOwner != address(0));
100       OwnershipTransferred(owner, newOwner);
101       owner = newOwner;
102     }
103 
104     /* Send Coins */
105     function transfer(address _to, uint256 _value) public {
106         require(_to != 0x0);
107         require(_value > 0);
108         require(balanceOf[msg.sender] >= _value );// Check if the sender has enough
109         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
110 
111         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); // Subtract from the sender
112         balanceOf[_to] = balanceOf[_to].add(_value);  // Add the same to the recipient
113         Transfer(msg.sender, _to, _value);   // Notify anyone listening that this transfer took place
114     }
115 
116     /* Allow another contract to spend some tokens in your behalf */
117     function approve(address _spender, uint256 _value) public returns (bool) {
118         require(_value > 0);
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     /* A contract attempts to get the coins */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != 0x0);
126         require(_value > 0);
127         require(balanceOf[_from] >= _value );// Check if the sender has enough
128         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
129         require(_value <= allowance[_from][msg.sender]); // Check allowance
130 
131         balanceOf[_from] = balanceOf[_from].sub(_value);   // Subtract from the sender
132         balanceOf[_to] = balanceOf[_to].add(_value);  // Add the same to the recipient
133         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function burn(uint256 _value) public onlyOwner returns (bool) {
139         require(balanceOf[msg.sender] >= _value);// Check if the sender has enough
140         require(_value > 0);
141 
142         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
143         totalSupply = totalSupply.sub(_value); // Updates totalSupply
144         Burn(msg.sender, _value);
145         return true;
146     }
147 
148     function freeze(uint256 _value) public returns (bool) {
149         require(balanceOf[msg.sender] >= _value);// Check if the sender has enough
150         require(_value > 0);
151 
152         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); // Subtract from the sender
153         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);  // Updates totalSupply
154         Freeze(msg.sender, _value);
155         return true;
156     }
157 
158     function unfreeze(uint256 _value) public returns (bool) {
159         require(freezeOf[msg.sender] >= _value); // Check if the sender has enough
160         require(_value > 0);
161 
162         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value); // Subtract from the sender
163         balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
164         Unfreeze(msg.sender, _value);
165         return true;
166     }
167 
168     // transfer contract balance to owner
169     function withdrawEther(uint256 amount) public onlyOwner {
170         owner.transfer(amount);
171     }
172 
173     // can accept ether
174     function() payable public {
175     }
176 }