1 pragma solidity  0.4.21;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9     address public newOwner;
10    
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21     /**
22     * @dev Throws if called by any account other than the owner.
23     */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30     * @dev Allows the current owner to transfer control of the contract to a newOwner.
31     * @param _newOwner The address to transfer ownership to.
32     */
33     function transferOwnership(address _newOwner) public onlyOwner {
34         require(address(0) != _newOwner);
35         newOwner = _newOwner;
36     }
37 
38     /**
39      * @dev Need newOwner to receive the Ownership.
40      */
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, msg.sender);
44         owner = msg.sender;
45         newOwner = address(0);
46     }
47 
48 }
49 
50 /**
51  * @title MultiToken
52  * @dev The interface of BCZERO Token contract.
53  */
54 contract IBCZEROToken {
55     function acceptOwnership() public;
56     function transfer(address _to, uint _value) public returns(bool);
57 }
58 /**
59  * @title BCZEROOwner
60  * @dev The management contract of BCZEROToken, to manage the ownership of Token contract.
61  */
62 contract BCZEROOwner is Ownable{
63     IBCZEROToken  BCZEROToken;
64     bool public exchangeEnabled; 
65     address  public BCZEROTokenAddr = 0xD45247c07379d94904E0A87b4481F0a1DDfa0C64; // the address of BCZERO Token.
66 
67     event WithdrawETH(uint256 amount);
68     event ExchangeEnabledStatus(bool enabled);
69     
70     /**
71      * @dev Constructor, setting the contract address of BCZERO token and the owner of this contract.
72      *      setting exchangeEnabled as true.
73      * @param _owner The owner of this contract.
74      */
75     function BCZEROOwner(address _owner) public {
76         BCZEROToken = IBCZEROToken(BCZEROTokenAddr);
77         owner = _owner;
78         exchangeEnabled = true; 
79     }
80 
81     /**
82      * @dev this contract to accept the ownership.
83      */
84     function acceptBCZEROOwnership() public onlyOwner {
85         BCZEROToken.acceptOwnership();
86     }
87     
88     /**
89      * @dev fallback, Let this contract can receive ETH
90      */
91     function() external payable {
92         require(exchangeEnabled);
93     }
94     
95     /**
96      * @dev Setting whether the BCZERO tokens can be exchanged.
97      * @param _enabled true or false
98      */
99     function setExchangeEnabled(bool _enabled) public onlyOwner {
100         exchangeEnabled = _enabled;
101         emit ExchangeEnabledStatus(_enabled);
102     }
103 
104     /**
105      * @dev Owner can transfer the ETH of this contract to the owner account by calling this function.
106      */
107     function withdrawETH() public onlyOwner {
108         uint256 amount = address(this).balance; // getting the balance of this contract（ETH）.
109         require(amount > 0);
110         owner.transfer(amount); // sending ETH to owner.
111         emit WithdrawETH(amount);
112     }
113     
114     /**
115      * @dev Owner can transfer the BCZERO token of this contract to the address 'to' by calling this function.
116      */
117     function transferBCZEROToken(address to, uint256 value) public onlyOwner {
118         BCZEROToken.transfer(to, value);
119     }
120     
121 }