1 pragma solidity ^0.4.11;
2 /*
3 Token Contract with batch assignments
4 
5 ERC-20 Token Standar Compliant
6 
7 Contract developer: Fares A. Akel C.
8 f.antonio.akel@gmail.com
9 MIT PGP KEY ID: 078E41CB
10 */
11 
12  contract token {
13 
14     function transfer(address _to, uint256 _value); 
15  
16  }
17 
18 
19 /**
20  * This contract is administered
21  */
22 
23 contract admined {
24     address public admin; //Admin address is public
25     /**
26     * @dev This constructor set the initial admin of the contract
27     */
28     function admined() internal {
29         admin = msg.sender; //Set initial admin to contract creator
30         Admined(admin);
31     }
32 
33     modifier onlyAdmin() { //A modifier to define admin-only functions
34         require(msg.sender == admin);
35         _;
36     }
37 
38     /**
39     * @dev Transfer the adminship of the contract
40     * @param _newAdmin The address of the new admin.
41     */
42     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
43         require(_newAdmin != address(0));
44         admin = _newAdmin;
45         TransferAdminship(admin);
46     }
47 
48     //All admin actions have a log for public review
49     event TransferAdminship(address newAdmin);
50     event Admined(address administrador);
51 }
52 
53 contract Sender is admined {
54     
55     token public ERC20Token;
56     
57     function Sender (token _addressOfToken) public {
58         ERC20Token = _addressOfToken; 
59     }
60     /**
61     * @dev batch the adminship of the contract
62     * @param _data Array of addresses.
63     * @param _amount amount to transfer per address.
64     */
65     function batch(address[] _data, uint256 _amount) onlyAdmin public { //It takes an array of addresses and an amount
66         for (uint i=0; i<_data.length; i++) { //It moves over the array
67             ERC20Token.transfer(_data[i], _amount);
68         }
69     }
70 
71     function() public {
72         revert();
73     }
74 }