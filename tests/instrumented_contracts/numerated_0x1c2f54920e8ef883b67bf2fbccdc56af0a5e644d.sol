1 pragma solidity ^0.4.24;
2 
3 contract Basic {
4 
5   address public owner;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   constructor() public {
10     owner = msg.sender;
11   }
12 
13   /**
14    * @dev Throws if called by any account other than the owner.
15    */
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   /**
22    * @dev Allows the current owner to transfer control of the contract to a newOwner.
23    * @param newOwner The address to transfer ownership to.
24    */
25   function transferOwnership(address newOwner) public onlyOwner {
26     require(newOwner != address(0));
27     emit OwnershipTransferred(owner, newOwner);
28     owner = newOwner;
29   }
30 
31 }
32 
33 contract Moses is Basic{
34 
35   event Attend(uint32 indexed id,string indexed attentHash);
36   event PublishResult(uint32 indexed id,string indexed result,bool indexed finish);
37 
38 
39   struct MoseEvent {
40     uint32 id;
41     string attendHash;
42     string result;
43     bool finish;
44   }
45 
46   mapping (uint32 => MoseEvent) internal moseEvents;
47 
48   /**
49   * @dev Storing predictive event participation information
50   *
51   * The contract owner collects the event participation information
52   * and stores the prediction event participation information
53   * @param _id  unique identification of predicted events
54   * @param _attendHash prediction event participation information hash value
55   */
56   function attend(uint32 _id,string _attendHash) public onlyOwner returns (bool) {
57     require(moseEvents[_id].id == uint32(0),"The event exists");
58     moseEvents[_id] = MoseEvent({id:_id, attendHash:_attendHash, result: "", finish:false});
59     emit Attend(_id, _attendHash);
60     return true;
61   }
62 
63   /**
64    * @dev Publish forecast event results
65    * @param _id unique identification of predicted events
66    * @param _result prediction result information
67    */
68   function publishResult(uint32 _id,string _result) public onlyOwner returns (bool) {
69     require(moseEvents[_id].id != uint32(0),"The event not exists");
70     require(!moseEvents[_id].finish,"The event has been completed");
71     moseEvents[_id].result = _result;
72     moseEvents[_id].finish = true;
73     emit PublishResult(_id, _result, true);
74     return true;
75   }
76 
77   /**
78    * Query the event to participate in the HASH by guessing the event ID
79    */
80   function showMoseEvent(uint32 _id) public view returns (uint32,string,string,bool) {
81     return (moseEvents[_id].id, moseEvents[_id].attendHash,moseEvents[_id].result,moseEvents[_id].finish);
82   }
83 
84 
85 }