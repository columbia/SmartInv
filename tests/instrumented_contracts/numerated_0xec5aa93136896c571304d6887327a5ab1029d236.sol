1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract BurnableToken {
41   function transferFrom(address, address, uint) public returns (bool);
42   function burn(uint) public;
43 }
44 
45 contract ReturnMANA is Ownable {
46 
47   // contract for mapping return address of vested accounts
48   ReturnVestingRegistry public returnVesting;
49 
50   // MANA Token
51   BurnableToken public token;
52 
53   // address of the contract that holds the reserve of staked MANA
54   address public terraformReserve;
55 
56   /**
57     * @dev Constructor
58     * @param _token MANA token contract address
59     * @param _terraformReserve address of the contract that holds the staked funds for the auction
60     * @param _returnVesting address of the contract for vested account mapping
61     */
62   function ReturnMANA(address _token, address _terraformReserve, address _returnVesting) public {
63     token = BurnableToken(_token);
64     returnVesting = ReturnVestingRegistry(_returnVesting);
65     terraformReserve = _terraformReserve;
66   }
67 
68   /**
69    * @dev Burn MANA
70    * @param _amount Amount of MANA to burn from terraform
71    */
72   function burnMana(uint256 _amount) onlyOwner public {
73     require(_amount > 0);
74     require(token.transferFrom(terraformReserve, this, _amount));
75     token.burn(_amount);
76   }
77 
78   /**
79    * @dev Transfer back remaining MANA to account
80    * @param _address Address of the account to return MANA to
81    * @param _amount Amount of MANA to return
82    */
83   function transferBackMANA(address _address, uint256 _amount) onlyOwner public {
84     require(_address != address(0));
85     require(_amount > 0);
86 
87     address returnAddress = _address;
88 
89     // Use vesting return address if present
90     if (returnVesting != address(0)) {
91       address mappedAddress = returnVesting.returnAddress(_address);
92       if (mappedAddress != address(0)) {
93         returnAddress = mappedAddress;
94       }
95     }
96 
97     // Funds are always transferred from reserve
98     require(token.transferFrom(terraformReserve, returnAddress, _amount));
99   }
100 
101   /**
102    * @dev Transfer back remaining MANA to multiple accounts
103    * @param _addresses Addresses of the accounts to return MANA to
104    * @param _amounts Amounts of MANA to return
105    */
106   function transferBackMANAMany(address[] _addresses, uint256[] _amounts) onlyOwner public {
107     require(_addresses.length == _amounts.length);
108 
109     for (uint256 i = 0; i < _addresses.length; i++) {
110       transferBackMANA(_addresses[i], _amounts[i]);
111     }
112   }
113 }
114 
115 contract ReturnVestingRegistry is Ownable {
116 
117   mapping (address => address) public returnAddress;
118 
119   function record(address from, address to) onlyOwner public {
120     require(from != 0);
121 
122     returnAddress[from] = to;
123   }
124 }