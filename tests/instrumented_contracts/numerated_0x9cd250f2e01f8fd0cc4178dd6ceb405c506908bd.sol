1 pragma solidity ^0.5.4;
2 contract Ownable {
3   address payable public owner;
4   event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   constructor() public {owner = msg.sender;}
11 
12   /**
13    * @dev Throws if called by any account other than the owner.
14    */
15   modifier onlyOwner() {
16     require(msg.sender == owner);
17     _;
18   }
19 
20 
21   /**
22    * @dev Allows the current owner to transfer control of the contract to a newOwner.
23    * @param _newOwner The address to transfer ownership to.
24    */
25   function transferOwnership(address payable _newOwner) public onlyOwner {
26     require(_newOwner != address(0));
27     emit OwnershipTransferred(owner, _newOwner);
28     owner = _newOwner;
29   }
30 }
31 contract FrenchIco_Coprorate is Ownable {
32     
33     bool internal PauseAllContracts= false;
34     uint public maxAmount;
35     mapping(address => uint) internal role;
36     
37     event WhitelistedAddress(address addr, uint _role);
38 
39 /** GENERAL STOPPABLE
40   * All the Project are stoppable by the Company
41   **/
42  
43     function GeneralPause() onlyOwner external {
44         if (PauseAllContracts==false) {PauseAllContracts=true;}
45         else {PauseAllContracts=false;}
46     }
47     
48     function setupMaxAmount(uint _maxAmount) onlyOwner external {
49         maxAmount = _maxAmount;
50     }
51 
52 
53 /** ROLE ATTRIBUTION
54      * @ Not registred = 0
55      * @ STANDARD = 1
56      * @ PREMIUM = 2
57      * @ PREMIUM PRO = 3
58       */   
59    
60     function RoleSetup(address addr, uint _role) onlyOwner public {
61          role[addr]= _role;
62          emit WhitelistedAddress(addr, _role);
63       }
64       
65     function newMember() public payable {
66          require (role[msg.sender]==0,"user has to be new");
67          role[msg.sender]= 1;
68          owner.transfer(msg.value);
69          emit WhitelistedAddress(msg.sender, 1);
70       }
71       
72 /** USABLE BY EXTERNAL CONTRACT*/ 
73 	     
74     function isGeneralPaused() external view returns (bool) {return PauseAllContracts;}
75     function GetRole(address addr) external view returns (uint) {return role[addr];}
76     function GetWallet_FRENCHICO() external view returns (address) {return owner;}
77     function GetMaxAmount() external view returns (uint) {return maxAmount;}
78 
79 }