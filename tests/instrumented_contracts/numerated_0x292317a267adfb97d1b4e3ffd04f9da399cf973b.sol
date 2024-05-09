1 pragma solidity ^ 0.4.16;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16    
17 }
18 contract tokenRecipient {
19     function  receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
20 }
21 
22 contract ERC20 is Ownable{
23     /* Public variables of the token */
24     string public standard = 'CREDITS';
25     string public name = 'CREDITS';
26     string public symbol = 'CS';
27     uint8 public decimals = 6;
28     uint256 public totalSupply = 1000000000000000;
29     bool public IsFrozen=false;
30     address public ICOAddress;
31 
32     /* This creates an array with all balances */
33     mapping(address => uint256) public balanceOf;
34     mapping(address => mapping(address => uint256)) public allowance;
35 
36     /* This generates a public event on the blockchain that will notify clients */
37     event Transfer(address indexed from, address indexed to, uint256 value);
38  modifier IsNotFrozen{
39       require(!IsFrozen||msg.sender==owner
40       ||msg.sender==0x0a6d9df476577C0D4A24EB50220fad007e444db8
41       ||msg.sender==ICOAddress);
42       _;
43   }
44     /* Initializes contract with initial supply tokens to the creator of the contract */
45     function ERC20() public {
46         balanceOf[msg.sender] = totalSupply;
47     }
48     function setICOAddress(address _address) public onlyOwner{
49         ICOAddress=_address;
50     }
51     
52    function setIsFrozen(bool _IsFrozen)public onlyOwner{
53       IsFrozen=_IsFrozen;
54     }
55     /* Send coins */
56     function transfer(address _to, uint256 _value) public IsNotFrozen {
57         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
58         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
59         balanceOf[msg.sender] -= _value; // Subtract from the sender
60         balanceOf[_to] += _value; // Add the same to the recipient
61         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
62     }
63   
64  
65     /* Allow another contract to spend some tokens in your behalf */
66     function approve(address _spender, uint256 _value)public
67     returns(bool success) {
68         allowance[msg.sender][_spender] = _value;
69         tokenRecipient spender = tokenRecipient(_spender);
70         return true;
71     }
72 
73     /* Approve and then comunicate the approved contract in a single tx */
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
75     returns(bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     /* A contract attempts to get the coins */
84     function transferFrom(address _from, address _to, uint256 _value)public IsNotFrozen returns(bool success)  {
85         require (balanceOf[_from] >= _value) ; // Check if the sender has enough
86         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
87         require (_value <= allowance[_from][msg.sender]) ; // Check allowance
88       
89         balanceOf[_from] -= _value; // Subtract from the sender
90         balanceOf[_to] += _value; // Add the same to the recipient
91         allowance[_from][msg.sender] -= _value;
92         Transfer(_from, _to, _value);
93         return true;
94     }
95  /* @param _value the amount of money to burn*/
96     event Burn(address indexed from, uint256 value);
97     function burn(uint256 _value) public onlyOwner  returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
99         balanceOf[msg.sender] -= _value;            // Subtract from the sender
100         totalSupply -= _value;                      // Updates totalSupply
101         Burn(msg.sender, _value);
102         return true;
103     }
104      // Optional token name
105 
106     
107     
108     function setName(string name_) public onlyOwner {
109         name = name_;
110     }
111     /* This unnamed function is called whenever someone tries to send ether to it */
112     function () public {
113      require(1==2) ; // Prevents accidental sending of ether
114     }
115 }