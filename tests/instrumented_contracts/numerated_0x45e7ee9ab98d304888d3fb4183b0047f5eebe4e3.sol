1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to relinquish control of the contract.
37     * @notice Renouncing to ownership will leave the contract without an owner.
38     * It will not be possible to call the functions with the `onlyOwner`
39     * modifier anymore.
40     */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47     * @dev Allows the current owner to transfer control of the contract to a newOwner.
48     * @param _newOwner The address to transfer ownership to.
49     */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55     * @dev Transfers control of the contract to a newOwner.
56     * @param _newOwner The address to transfer ownership to.
57     */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 
66 /** @title Restricted
67  *  Exposes onlyMonetha modifier
68  */
69 contract Restricted is Ownable {
70 
71     event MonethaAddressSet(
72         address _address,
73         bool _isMonethaAddress
74     );
75 
76     mapping (address => bool) public isMonethaAddress;
77 
78     /**
79      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
80      */
81     modifier onlyMonetha() {
82         require(isMonethaAddress[msg.sender]);
83         _;
84     }
85 
86     /**
87      *  Allows owner to set new monetha address
88      */
89     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
90         isMonethaAddress[_address] = _isMonethaAddress;
91 
92         MonethaAddressSet(_address, _isMonethaAddress);
93     }
94 }
95 
96 
97 /**
98  *  @title MonethaSupportedTokens
99  *
100  *  MonethaSupportedTokens stores all erc20 token supported by Monetha
101  */
102 contract MonethaSupportedTokens is Restricted {
103     
104     string constant VERSION = "0.1";
105     
106     struct Token {
107         bytes32 token_acronym;
108         address token_address;
109     }
110     
111     mapping (uint => Token) public tokens;
112 
113     uint public tokenId;
114     
115     address[] private allAddresses;
116     bytes32[] private allAccronym;
117     
118     function addToken(bytes32 _tokenAcronym, address _tokenAddress)
119         external onlyMonetha
120     {
121         require(_tokenAddress != address(0));
122 
123         tokens[++tokenId] = Token({
124             token_acronym: bytes32(_tokenAcronym),
125             token_address: _tokenAddress
126         });
127         allAddresses.push(_tokenAddress);
128         allAccronym.push(bytes32(_tokenAcronym));
129     }
130     
131     function deleteToken(uint _tokenId)
132         external onlyMonetha
133     {
134         
135         tokens[_tokenId].token_address = tokens[tokenId].token_address;
136         tokens[_tokenId].token_acronym = tokens[tokenId].token_acronym;
137 
138         uint len = allAddresses.length;
139         allAddresses[_tokenId-1] = allAddresses[len-1];
140         allAccronym[_tokenId-1] = allAccronym[len-1];
141         allAddresses.length--;
142         allAccronym.length--;
143         delete tokens[tokenId];
144         tokenId--;
145     }
146     
147     function getAll() external view returns (address[], bytes32[])
148     {
149         return (allAddresses, allAccronym);
150     }
151     
152 }