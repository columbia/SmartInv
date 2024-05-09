1 pragma solidity ^ 0.4.15;
2 
3 
4 /**
5 *contract name : tokenRecipient
6 */
7 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
8 
9 
10 /**
11 *contract name : GodzStartupBasicInformation
12 *purpose : be the smart contract for the erc20 tokenof the startup
13 *goal : to achieve to be the smart contract that the startup use for his stokcs
14 */
15 contract GodzStartupBasicInformation {
16     string public name;
17     string public symbol;
18     uint8 public decimals;
19     uint256 public totalSupply;
20 
21     uint256 public amount;
22     uint256 public reward; /*reward offered for the voters*/
23     address public owner;
24 
25     mapping(address => uint256) public balanceOf;
26     mapping(address => mapping(address => uint256)) public allowance;
27 
28     function GodzStartupBasicInformation(
29         uint256 initialSupply,
30         string tokenName,
31         uint8 decimalUnits,
32         string tokenSymbol,
33         uint256 _amount,
34         uint256 _reward, /*reward offered for the voters*/
35         address _GodzSwapTokens /*address of the smart contract token swap*/
36     ) {
37         owner = tx.origin; /*becasuse the contract creation is controlled by the smart contract controller we use tx.origin*/
38         balanceOf[owner] = initialSupply;
39 
40         totalSupply = initialSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43         decimals = decimalUnits;
44 
45         amount = _amount; /*amount of the erc20 token*/
46         reward = _reward; /*reward offered for the voters*/
47 
48         allowance[owner][_GodzSwapTokens] = initialSupply; /*here will allow the tokens transfer to the smart contract swap token*/
49     }
50 
51      /* Send coins */
52     function transfer(address _to, uint256 _value) {
53         if (_to == 0x0) revert();                               /* Prevent transfer to 0x0 address. Use burn() instead*/
54         if (balanceOf[msg.sender] < _value) revert();           /* Check if the sender has enough*/
55         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); /* Check for overflows*/
56         balanceOf[msg.sender] -= _value;                        /* Subtract from the sender*/
57         balanceOf[_to] += _value;                               /* Add the same to the recipient*/
58     }
59 
60     /* Allow another contract to spend some tokens in your behalf */
61     function approve(address _spender, uint256 _value)
62         returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 
67     /* Approve and then communicate the approved contract in a single tx */
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69         returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76 
77     /* A contract attempts to get the coins but transfer from the origin*/
78     function transferFromOrigin(address _to, uint256 _value)  returns (bool success) {
79         address origin = tx.origin;
80         if (origin == 0x0) revert();
81         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
82         if (balanceOf[origin] < _value) revert();                /* Check if the sender has enough*/
83         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
84         balanceOf[origin] -= _value;                             /* Subtract from the sender*/
85         balanceOf[_to] += _value;                                /* Add the same to the recipient*/
86         return true;
87     }
88 
89     /* A contract attempts to get the coins */
90     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
91         if (_to == 0x0) revert();                                /* Prevent transfer to 0x0 address.*/
92         if (balanceOf[_from] < _value) revert();                 /* Check if the sender has enough*/
93         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  /* Check for overflows*/
94         if (_value > allowance[_from][msg.sender]) revert();     /* Check allowance*/
95         balanceOf[_from] -= _value;                              /* Subtract from the sender*/
96         balanceOf[_to] += _value;                                /* Add the same to the recipient*/
97         allowance[_from][msg.sender] -= _value;
98         return true;
99     }
100 }