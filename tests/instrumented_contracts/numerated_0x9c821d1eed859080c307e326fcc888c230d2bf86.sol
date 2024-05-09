1 pragma solidity ^0.4.11;
2 /**
3 * Token Batch assignments 
4 */
5 
6  contract token {
7 
8     function balanceOf(address _owner) public returns (uint256 bal);
9     function transfer(address _to, uint256 _value) public returns (bool); 
10  
11  }
12 
13 
14 /**
15  * This contract is administered
16  */
17 
18 contract admined {
19     address public admin; //Admin address is public
20     /**
21     * @dev This constructor set the initial admin of the contract
22     */
23     function admined() internal {
24         admin = msg.sender; //Set initial admin to contract creator
25         Admined(admin);
26     }
27 
28     modifier onlyAdmin() { //A modifier to define admin-only functions
29         require(msg.sender == admin);
30         _;
31     }
32 
33     /**
34     * @dev Transfer the adminship of the contract
35     * @param _newAdmin The address of the new admin.
36     */
37     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
38         require(_newAdmin != address(0));
39         admin = _newAdmin;
40         TransferAdminship(admin);
41     }
42 
43     //All admin actions have a log for public review
44     event TransferAdminship(address newAdmin);
45     event Admined(address administrador);
46 }
47 
48 contract Sender is admined {
49     
50     token public ERC20Token;
51     mapping (address => bool) public flag; //Balances mapping
52     uint256 public price; //with all decimals
53     
54     function Sender (token _addressOfToken, uint256 _initialPrice) public {
55         price = _initialPrice;
56         ERC20Token = _addressOfToken; 
57     }
58 
59     function updatePrice(uint256 _newPrice) onlyAdmin public {
60         price = _newPrice;
61     }
62 
63     function contribute() public payable { //It takes an array of addresses and an amount
64         require(flag[msg.sender] == false);
65         flag[msg.sender] = true;
66         ERC20Token.transfer(msg.sender,price);
67     }
68 
69     function withdraw() onlyAdmin public{
70         require(admin.send(this.balance));
71         ERC20Token.transfer(admin, ERC20Token.balanceOf(this));
72     }
73 
74     function() public payable {
75         contribute();
76     }
77 }