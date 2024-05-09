1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15  function Ownable() {
16     owner = msg.sender;
17   }
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));
31     emit OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 }
35 /**
36  * @title Blueprint
37  */
38 contract Blueprint is Ownable {
39    
40     struct BlueprintInfo {
41         bytes32 details;
42         address creator;
43         uint256 createTime;
44     }
45     //BluePrint Info
46     mapping(string => BlueprintInfo) private  _bluePrint;
47     
48     /**
49    * @dev Create Exchange details.
50    * @param _id unique id.
51    * @param _details exchange details.
52    */
53 
54     function createExchange(string _id,string _details) public onlyOwner
55           
56     returns (bool)
57    
58     {
59          BlueprintInfo memory info;
60          info.details=sha256(_details);
61          info.creator=msg.sender;
62          info.createTime=block.timestamp;
63          _bluePrint[_id] = info;
64          return true;
65          
66     }
67     
68     /**
69   * @dev Gets the BluePrint details of the specified id.
70   */
71   function getBluePrint(string _id) public view returns (bytes32,address,uint256) {
72     return (_bluePrint[_id].details,_bluePrint[_id].creator,_bluePrint[_id].createTime);
73   }
74     
75 }