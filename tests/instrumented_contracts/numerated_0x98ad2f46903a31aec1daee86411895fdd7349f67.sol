1 pragma solidity ^0.4.19;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 
39 contract TokenInterface {
40     function balanceOf(address _who) public view returns (uint256);
41     function transfer(address _to, uint256 _value) public returns (bool);
42 }
43 
44 
45 
46 contract Airdrop is Ownable {
47     
48     TokenInterface token;
49     
50     event NewTokenAddress(address indexed ERC20_ADDRESS);
51     event TokensWithdrawn(address indexed ERC20_ADDRESS, uint256 TOTAL);
52     event AirdropInvoked();
53     
54     /**
55      * Allows the owner of the contract to change the token to be airdropped
56      * 
57      * @param _newTokenAddress The address of the token
58      * @return True if function executes, false otherwise
59      * */
60     function setTokenAddress(address _newTokenAddress) public onlyOwner returns(bool) {
61         require(_newTokenAddress != address(token));
62         require(_newTokenAddress != address(0));
63         token = TokenInterface(_newTokenAddress);
64         NewTokenAddress(_newTokenAddress);
65         return true;
66     }
67     
68 
69     /**
70      * Allows the owner of the contract to airdrop tokens using multiple values 
71      * 
72      * @param _addrs The array of recipient addresses
73      * @param _values The array of values (i.e., tokens) each corresponding address 
74      * will receive.
75      * @return True if function executes, false otherwise
76      * */
77     function multiValueAirDrop(address[] _addrs, uint256[] _values) public onlyOwner returns(bool) {
78 	    require(_addrs.length == _values.length && _addrs.length <= 100);
79         for (uint i = 0; i < _addrs.length; i++) {
80             if (_addrs[i] != 0x0 && _values[i] > 0) {
81                 token.transfer(_addrs[i], _values[i]);  
82             }
83         }
84         AirdropInvoked();
85         return true;
86     }
87 
88 
89     /**
90      * Allows the owner of the contract to airdrop tokens of a single value
91      * 
92      * @param _addrs The array of recipient addresses
93      * @param _value The amount of tokens each address will receive
94      * @return True if function executes, false otherwise
95      * */
96     function singleValueAirDrop(address[] _addrs, uint256 _value) public onlyOwner returns(bool){
97 	    require(_addrs.length <= 100 && _value > 0);
98         for (uint i = 0; i < _addrs.length; i++) {
99             if (_addrs[i] != 0x0) {
100                 token.transfer(_addrs[i], _value);
101             }
102         }
103         AirdropInvoked();
104         return true;
105     }
106     
107     
108     /**
109      * Allows the owner of the contract to withdraw tokens from the contract
110      * 
111      * @param _addressOfToken The address of the tokens to be withdrawn 
112      * @return True if function executes, false otherwise
113      * */
114     function withdrawTokens(address _addressOfToken) public onlyOwner returns(bool) {
115         TokenInterface tkn = TokenInterface(_addressOfToken);
116         if(tkn.balanceOf(address(this)) == 0) {
117             revert();
118         }
119         TokensWithdrawn(_addressOfToken, tkn.balanceOf(address(this)));
120         tkn.transfer(owner, tkn.balanceOf(address(this)));
121     }
122 }