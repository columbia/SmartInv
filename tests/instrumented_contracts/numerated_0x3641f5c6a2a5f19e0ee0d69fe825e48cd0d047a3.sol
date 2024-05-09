1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {owner = msg.sender;}
6     modifier onlyOwner { require(msg.sender == owner); _;}
7     function transferOwnership(address newOwner) onlyOwner public {owner = newOwner;}
8 }
9 
10 //interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
11 
12 contract EmrCrowdfund is owned {
13     string public name;
14     string public symbol;
15     uint8 public decimals = 12;
16     uint256 public totalSupply;
17     uint256 public tokenPrice;
18 
19     mapping (address => uint256) public balanceOf;
20     mapping (address => bool) public frozenAccount;
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Burn(address indexed from, uint256 value);
24     event FrozenFunds(address target, bool frozen);
25 
26     /**
27      * Constrctor function
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     function EmrCrowdfund(
31         uint256 initialSupply,
32         uint256 _tokenPrice,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         tokenPrice = _tokenPrice / 10 ** uint256(decimals);
37         totalSupply = initialSupply * 10 ** uint256(decimals);
38         name = tokenName;
39         symbol = tokenSymbol;
40     }
41 
42     /* Internal transfer, only can be called by this contract */
43     function _transfer(address _from, address _to, uint _value) internal {
44         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
45         require (balanceOf[_from] >= _value);               // Check if the sender has enough
46         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
47         require(!frozenAccount[_from]);                     // Check if sender is frozen
48         require(!frozenAccount[_to]);                       // Check if recipient is frozen
49         balanceOf[_from] -= _value;                         // Subtract from the sender
50         balanceOf[_to] += _value;                           // Add the same to the recipient
51         emit Transfer(_from, _to, _value);
52     }
53 
54     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
55     /// @param target Address to be frozen
56     /// @param freeze either to freeze it or not
57     function freezeAccount(address target, bool freeze) onlyOwner public {
58         frozenAccount[target] = freeze;
59         emit FrozenFunds(target, freeze);
60     }
61 
62     /**
63      * Transfer tokens
64      * Send `_value` tokens to `_to` from your account
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transfer(address _to, uint256 _value) public {
69         _transfer(msg.sender, _to, _value);
70     }
71 
72     /**
73      * Destroy tokens from other account
74      *
75      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
76      *
77      * @param _from the address of the sender
78      * @param _value the amount of money to burn
79      */
80     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
81         require(balanceOf[_from] >= _value);
82         balanceOf[_from] -= _value;
83         totalSupply -= _value;
84         emit Burn(_from, _value);
85         return true;
86     }
87 
88     /** @notice Allow users to buy tokens and sell tokens for eth
89     *   @param _tokenPrice Price the users can sell or buy
90     */
91     function setPrices(uint256 _tokenPrice) onlyOwner public {
92         tokenPrice = _tokenPrice;
93     }
94 
95     function() payable public{
96         buy();
97     }
98 
99     /// @notice Buy tokens from contract by sending ether
100     function buy() payable public {
101         uint amount = msg.value / tokenPrice;
102         require (totalSupply >= amount);
103         require(!frozenAccount[msg.sender]);
104         totalSupply -= amount;
105         balanceOf[msg.sender] += amount;
106         emit Transfer(address(0), msg.sender, amount);
107     }
108 
109     function withdrawAll() onlyOwner public {
110         owner.transfer(address(this).balance);
111     }
112 }