1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner, "Only the owner may call this method.");
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param _newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address _newOwner) public onlyOwner {
38     _transferOwnership(_newOwner);
39   }
40 
41   /**
42    * @dev Transfers control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function _transferOwnership(address _newOwner) internal {
46     require(_newOwner != address(0), "Invalid owner address");
47     emit OwnershipTransferred(owner, _newOwner);
48     owner = _newOwner;
49   }
50 }
51 
52 contract ReviewThisPlease is Ownable 
53 {
54     /*******************************************
55      * Data
56      *******************************************/
57     event Accept(string topic, uint256 value);
58     event Decline(string topic, uint256 value);
59     event NewTopic(string topic, address from, uint256 value);
60     event ContributeToTopic(string topic, address from, uint256 value);
61     
62     struct Supporter 
63     {
64         address addr;
65         uint256 value;
66     }
67     struct SupporterList
68     {
69         mapping(uint256 => Supporter) idToSupporter;
70         uint256 length;
71     }
72     struct TopicList
73     {
74         mapping(uint256 => string) idToTopic;
75         uint256 length;
76     }
77     
78     uint256 public minForNewTopic;
79     uint256 public minForExistingTopic;
80    
81     mapping(string => SupporterList) private topicToSupporterList;
82     mapping(address => TopicList) private supporterToTopicList;
83     TopicList private allTopics;
84     
85     /*******************************************
86      * Admin
87      *******************************************/
88     constructor() public 
89     {
90         minForNewTopic = 0.05 ether;
91         minForExistingTopic = 0.001 ether;
92     }
93     
94     function setMins(uint256 _minForNewTopic, uint256 _minForExistingTopic)
95         onlyOwner public 
96     {
97         require(_minForNewTopic > 0, 
98             "The _minForNewTopic should be > 0.");
99         require(_minForExistingTopic > 0, 
100             "The _minForExistingTopic should be > 0.");
101         
102         minForNewTopic = _minForNewTopic;
103         minForExistingTopic = _minForExistingTopic;
104     }
105     
106     /*******************************************
107      * Read only
108      *******************************************/
109     function getTopicCount() public view returns (uint256)
110     {
111         return allTopics.length;
112     }
113     
114     function getTopic(uint256 id) public view returns (string)
115     {
116         return allTopics.idToTopic[id];
117     }
118     
119     function getSupportersForTopic(string topic) public view 
120         returns (address[], uint256[])
121     {
122         SupporterList storage supporterList = topicToSupporterList[topic];
123         
124         address[] memory addressList = new address[](supporterList.length);
125         uint256[] memory valueList = new uint256[](supporterList.length);
126         
127         for(uint i = 0; i < supporterList.length; i++)
128         {
129             Supporter memory supporter = supporterList.idToSupporter[i];
130             addressList[i] = supporter.addr;
131             valueList[i] = supporter.value;
132         }
133         
134         return (addressList, valueList);
135     }
136     
137     /*******************************************
138      * Public write
139      *******************************************/
140     function requestTopic(string topic) public payable
141     {
142         require(bytes(topic).length > 0, 
143             "Please specify a topic.");
144         require(bytes(topic).length <= 500, 
145             "The topic is too long (max 500 characters).");
146             
147         SupporterList storage supporterList = topicToSupporterList[topic];
148         
149         if(supporterList.length == 0)
150         { // New topic
151             require(msg.value >= minForNewTopic, 
152                 "Please send at least 'minForNewTopic' to request a new topic.");
153           
154             allTopics.idToTopic[allTopics.length++] = topic;
155             emit NewTopic(topic, msg.sender, msg.value);
156         }
157         else
158         { // Existing topic
159             require(msg.value >= minForExistingTopic, 
160                 "Please send at least 'minForExistingTopic' to add support to an existing topic.");
161         
162             emit ContributeToTopic(topic, msg.sender, msg.value);
163         }
164         
165         supporterList.idToSupporter[supporterList.length++] = 
166             Supporter(msg.sender, msg.value);
167     }
168 
169     function refund(string topic) public returns (bool)
170     {
171         SupporterList storage supporterList = topicToSupporterList[topic];
172         uint256 amountToRefund = 0;
173         for(uint i = 0; i < supporterList.length; i++)
174         {
175             Supporter memory supporter = supporterList.idToSupporter[i];
176             if(supporter.addr == msg.sender)
177             {
178                 amountToRefund += supporter.value;
179                 supporterList.idToSupporter[i] = supporterList.idToSupporter[--supporterList.length];
180                 i--;
181             }
182         }
183         
184         bool topicWasRemoved = false;
185         if(supporterList.length == 0)
186         {
187             _removeTopic(topic);
188             topicWasRemoved = true;
189         }
190         
191         msg.sender.transfer(amountToRefund);
192         
193         return (topicWasRemoved);
194     }
195     
196     function refundAll() public
197     {
198         for(uint i = 0; i < allTopics.length; i++)
199         {
200             if(refund(allTopics.idToTopic[i]))
201             {
202                 i--;
203             }
204         }
205     }
206     
207     /*******************************************
208      * Owner only write
209      *******************************************/
210     function accept(string topic) public onlyOwner
211     {
212         SupporterList storage supporterList = topicToSupporterList[topic];
213         uint256 totalValue = 0;
214         for(uint i = 0; i < supporterList.length; i++)
215         {
216             totalValue += supporterList.idToSupporter[i].value;
217         }
218        
219         _removeTopic(topic);
220         emit Accept(topic, totalValue);
221         
222         owner.transfer(totalValue);
223     }
224     
225     function decline(string topic) public onlyOwner
226     {
227         SupporterList storage supporterList = topicToSupporterList[topic];
228         uint256 totalValue = 0;
229         for(uint i = 0; i < supporterList.length; i++)
230         {
231             totalValue += supporterList.idToSupporter[i].value;
232             supporterList.idToSupporter[i].addr.transfer(
233                 supporterList.idToSupporter[i].value);
234         }
235         
236         _removeTopic(topic);
237         emit Decline(topic, totalValue);
238     }
239     
240     function declineAll() public onlyOwner
241     {
242         for(uint i = 0; i < allTopics.length; i++)
243         {
244             decline(allTopics.idToTopic[i]);
245         }
246     }
247     
248     /*******************************************
249      * Private helpers
250      *******************************************/
251     function _removeTopic(string topic) private
252     {
253         delete topicToSupporterList[topic];
254         bytes32 topicHash = keccak256(abi.encodePacked(topic));
255         for(uint i = 0; i < allTopics.length; i++)
256         {
257             string memory _topic = allTopics.idToTopic[i];
258             if(keccak256(abi.encodePacked(_topic)) == topicHash)
259             {
260                 allTopics.idToTopic[i] = allTopics.idToTopic[--allTopics.length];
261                 return;
262             }
263         }
264     }
265 }