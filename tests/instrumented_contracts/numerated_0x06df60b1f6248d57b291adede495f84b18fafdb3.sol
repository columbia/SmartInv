1 contract Destructible {
2 
3 /**
4 * @dev mapping of security => (investorEthAddress, investerInfo)
5 */
6     address _owner; //owner of this contract
7 
8  /*
9  * event emitted when ethers received in this contract
10  */
11     event receipt(address indexed investor, uint value);
12 
13 /**
14 * @dev Modifier to make a function callable only by the owner of the contract
15 */
16     modifier onlyOwner() {
17         require(msg.sender == _owner);
18         _;
19     }
20 
21   /**
22    * @dev Constructor of the Destructible
23    */ 
24     constructor() public {
25         _owner = msg.sender;
26     }
27 
28     /**
29     * @dev 
30     * Payable fallback function. 
31     * Function just emits event to be inline with 2300 gas limitation for fallback functions
32     */
33     function() payable public {
34         emit receipt(msg.sender, msg.value);
35     }
36        
37     /**
38     * @dev 
39     * destroyAndSend 
40     * @param _recipient is the recipient address to which fund held by this contract are to be remitted on selfdestruction
41     */
42 
43     function destroyAndSend(address _recipient) onlyOwner() public {
44         selfdestruct(_recipient);
45     }
46 
47 }