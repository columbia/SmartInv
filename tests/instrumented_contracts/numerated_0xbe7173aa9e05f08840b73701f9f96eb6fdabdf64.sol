1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;
5     function owned() public {owner = msg.sender;}
6     modifier onlyOwner { require(msg.sender == owner); _;}
7     function transferOwnership(address newOwner) onlyOwner public {owner = newOwner;}
8 }
9 
10 contract EmrCrowdfund is owned {
11     string public name;
12     string public symbol;
13     uint8 public decimals = 12;
14     uint256 public totalSupply;
15     uint256 public tokenPrice;
16 
17     mapping (address => uint256) public balanceOf;
18     mapping (address => bool) public frozenAccount;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Burn(address indexed from, uint256 value);
22     event FrozenFunds(address target, bool frozen);
23 
24     function EmrCrowdfund(
25         uint256 initialSupply,
26         uint256 _tokenPrice,
27         string tokenName,
28         string tokenSymbol
29     ) public {
30         tokenPrice = _tokenPrice / 10 ** uint256(decimals);
31         totalSupply = initialSupply * 10 ** uint256(decimals);
32         name = tokenName;
33         symbol = tokenSymbol;
34     }
35 
36     function _transfer(address _from, address _to, uint _value) internal {
37         require (_to != 0x0);
38         require (balanceOf[_from] >= _value);
39         require (balanceOf[_to] + _value >= balanceOf[_to]);
40         require(!frozenAccount[_from]);
41         require(!frozenAccount[_to]);
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45     }
46 
47     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
48     /// @param target Address to be frozen
49     /// @param freeze either to freeze it or not
50     function freezeAccount(address target, bool freeze) onlyOwner public {
51         frozenAccount[target] = freeze;
52         emit FrozenFunds(target, freeze);
53     }
54 
55     /**
56      * @notice Transfer tokens
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     /**
65      * @notice Destroy tokens from other account
66      * @param _from the address of the owner
67      * @param _value the amount of money to burn
68      */
69     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
70         require(balanceOf[_from] >= _value);
71         balanceOf[_from] -= _value;
72         totalSupply -= _value;
73         emit Burn(_from, _value);
74         return true;
75     }
76 
77     /** @notice Allow users to buy tokens for eth
78     *   @param _tokenPrice Price the users can buy
79     */
80     function setPrices(uint256 _tokenPrice) onlyOwner public {
81         tokenPrice = _tokenPrice;
82     }
83 
84     function() payable public{
85         buy();
86     }
87 
88     /// @notice Buy tokens from contract by sending ether
89     function buy() payable public {
90         uint amount = msg.value / tokenPrice;
91         require (totalSupply >= amount);
92         require(!frozenAccount[msg.sender]);
93         totalSupply -= amount;
94         balanceOf[msg.sender] += amount;
95         emit Transfer(address(0), msg.sender, amount);
96     }
97 
98     /**
99     * @notice Manual transfer for investors who paid from payment cards
100     * @param _to the address of the receiver
101     * @param _value the amount of tokens
102     */
103     function manualTransfer(address _to, uint256 _value) public onlyOwner returns (bool success) {
104         require (totalSupply >= _value);
105         require(!frozenAccount[_to]);
106         totalSupply -= _value;
107         balanceOf[_to] += _value;
108         emit Transfer(address(0), _to, _value);
109         return true;
110     }
111 
112     /// @notice Withdraw ether to owner account
113     function withdrawAll() onlyOwner public {
114         owner.transfer(address(this).balance);
115     }
116 }