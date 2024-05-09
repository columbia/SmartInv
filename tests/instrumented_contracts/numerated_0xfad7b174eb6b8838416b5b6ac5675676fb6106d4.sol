1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BITStationERC20  {
6     // Public variables of the token
7     address public owner;
8     string public name;
9     string public symbol;
10     uint8 public decimals = 7;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13 	bool public isLocked;
14 	//uint private lockTime;
15 	//uint public lockDays;
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 	mapping (address => bool) public whiteList;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24 	
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     function  BITStationERC20() public {
31         totalSupply = 120000000000000000;  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = 120000000000000000;                // Give the creator all initial tokens
33 		owner = msg.sender;
34         name = "BIT Station";                                   // Set the name for display purposes
35         symbol = "BSTN";                               // Set the symbol for display purposes
36         isLocked=true;
37 		//lockTime=now;
38 		//lockDays=lockdays;
39 		whiteList[owner]=true;
40     }
41 	modifier onlyOwner() {
42 		require(msg.sender == owner);
43 		_;
44 	}
45   
46 	function transferOwnership(address newOwner) onlyOwner public{
47     if (newOwner != address(0)) {
48       owner = newOwner;
49 	  whiteList[owner]=true;
50     }
51   }
52 	/*
53 	modifier disableLock() 
54 	{ 
55 		if (now >= lockTime+ lockDays *1 days )
56 		{
57 			if(isLocked)
58 				isLocked=!isLocked;
59 		}	
60 		_; 
61 	}
62 	*/
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(!isLocked||whiteList[msg.sender]);
69 		require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value > balanceOf[_to]);
74         // Save this for an assertion in the future
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         // Subtract from the sender
77         balanceOf[_from] -= _value;
78         // Add the same to the recipient
79         balanceOf[_to] += _value;
80         Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public {
94 		
95         _transfer(msg.sender, _to, _value);
96     }
97 
98     /**
99      * Transfer tokens from other address
100      *
101      * Send `_value` tokens to `_to` in behalf of `_from`
102      *
103      * @param _from The address of the sender
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transferFrom(address _from, address _to, uint256 _value) public 
108 	returns (bool success) {
109 		require(!isLocked||whiteList[msg.sender]);
110         require(_value <= allowance[_from][msg.sender]);     // Check allowance
111         allowance[_from][msg.sender] -= _value;
112         _transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      */
124     function approve(address _spender, uint256 _value) public 
125         returns (bool success) {
126 		require(!isLocked);
127         allowance[msg.sender][_spender] = _value;
128         return true;
129         }
130 	function addWhiteList(address _value) public onlyOwner
131 	    {
132 		    whiteList[_value]=true;
133 	    }
134 	function delFromWhiteList(address _value) public onlyOwner
135 	    {
136 	    	whiteList[_value]=false;	
137 	    }
138 	
139     /**
140      * Set allowance for other address and notify
141      *
142      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      * @param _extraData some extra information to send to the approved contract
147      */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public 
149         returns (bool success) {
150 		require(!isLocked);
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, this, _extraData);
154             return true;
155         }
156     }
157 	function changeAssetsState(bool _value) public
158 	returns (bool success){
159     	require(msg.sender==owner);
160 	    isLocked =_value;
161 	    return true;
162 	}
163 }