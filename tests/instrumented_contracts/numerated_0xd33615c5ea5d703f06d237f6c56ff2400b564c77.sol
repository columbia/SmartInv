1 pragma solidity ^0.4.24;
2 
3 //Slightly modified SafeMath library - includes a min function
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function min(uint a, uint b) internal pure returns (uint256) {
30     return a < b ? a : b;
31   }
32 }
33 
34 
35 
36 /**
37 *This contract allows users to sign up for the DDA Cooperative Membership.
38 *To complete membership DDA will provide instructions to complete KYC/AML verification
39 *through a system external to this contract.
40 */
41 contract Membership {
42     using SafeMath for uint256;
43     
44     /*Variables*/
45     address public owner;
46     //Memebership fees
47     uint public memberFee;
48 
49     /*Structs*/
50     /**
51     *@dev Keeps member information 
52     */
53     struct Member {
54         uint memberId;
55         uint membershipType;
56     }
57     
58     /*Mappings*/
59     //Members information
60     mapping(address => Member) public members;
61     address[] public membersAccts;
62     mapping (address => uint) public membersAcctsIndex;
63 
64     /*Events*/
65     event UpdateMemberAddress(address _from, address _to);
66     event NewMember(address _address, uint _memberId, uint _membershipType);
67     event Refund(address _address, uint _amount);
68 
69     /*Modifiers*/
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74     
75     /*Functions*/
76     /**
77     *@dev Constructor - Sets owner
78     */
79      constructor() public {
80         owner = msg.sender;
81     }
82 
83     /*
84     *@dev Updates the fee amount
85     *@param _memberFee fee amount for member
86     */
87     function setFee(uint _memberFee) public onlyOwner() {
88         //define fee structure for the three membership types
89         memberFee = _memberFee;
90     }
91     
92     /**
93     *@notice Allows a user to become DDA members if they pay the fee. However, they still have to complete
94     *complete KYC/AML verification off line
95     *@dev This creates and transfers the token to the msg.sender
96     */
97     function requestMembership() public payable {
98         Member storage sender = members[msg.sender];
99         require(msg.value >= memberFee && sender.membershipType == 0 );
100         membersAccts.push(msg.sender);
101         sender.memberId = membersAccts.length;
102         sender.membershipType = 1;
103         emit NewMember(msg.sender, sender.memberId, sender.membershipType);
104     }
105     
106     /**
107     *@dev This updates/transfers the member address 
108     *@param _from is the current member address
109     *@param _to is the address the member would like to update their current address with
110     */
111     function updateMemberAddress(address _from, address _to) public onlyOwner {
112         require(_to != address(0));
113         Member storage currentAddress = members[_from];
114         Member storage newAddress = members[_to];
115         require(newAddress.memberId == 0);
116         newAddress.memberId = currentAddress.memberId;
117         newAddress.membershipType = currentAddress.membershipType;
118         membersAccts[currentAddress.memberId - 1] = _to;
119         currentAddress.memberId = 0;
120         currentAddress.membershipType = 0;
121         emit UpdateMemberAddress(_from, _to);
122     }
123 
124     /**
125     *@dev Use this function to set membershipType for the member
126     *@param _memberAddress address of member that we need to update membershipType
127     *@param _membershipType type of membership to assign to member
128     */
129     function setMembershipType(address _memberAddress,  uint _membershipType) public onlyOwner{
130         Member storage memberAddress = members[_memberAddress];
131         memberAddress.membershipType = _membershipType;
132     }
133 
134     /**
135     *@dev Use this function to set memberId for the member
136     *@param _memberAddress address of member that we need to update membershipType
137     *@param _memberId is the manually assigned memberId
138     */
139     function setMemberId(address _memberAddress,  uint _memberId) public onlyOwner{
140         Member storage memberAddress = members[_memberAddress];
141         memberAddress.memberId = _memberId;
142     }
143 
144     /**
145     *@dev Use this function to remove member acct from array memberAcct
146     *@param _memberAddress address of member to remove
147     */
148     function removeMemberAcct(address _memberAddress) public onlyOwner{
149         require(_memberAddress != address(0));
150         uint256 indexToDelete;
151         uint256 lastAcctIndex;
152         address lastAdd;
153         Member storage memberAddress = members[_memberAddress];
154         memberAddress.memberId = 0;
155         memberAddress.membershipType = 0;
156         indexToDelete = membersAcctsIndex[_memberAddress];
157         lastAcctIndex = membersAccts.length.sub(1);
158         lastAdd = membersAccts[lastAcctIndex];
159         membersAccts[indexToDelete]=lastAdd;
160         membersAcctsIndex[lastAdd] = indexToDelete;   
161         membersAccts.length--;
162         membersAcctsIndex[_memberAddress]=0; 
163     }
164 
165 
166     /**
167     *@dev Use this function to member acct from array memberAcct
168     *@param _memberAddress address of member to add
169     */
170     function addMemberAcct(address _memberAddress) public onlyOwner{
171         require(_memberAddress != address(0));
172         Member storage memberAddress = members[_memberAddress];
173         membersAcctsIndex[_memberAddress] = membersAccts.length; 
174         membersAccts.push(_memberAddress);
175         memberAddress.memberId = membersAccts.length;
176         memberAddress.membershipType = 1;
177         emit NewMember(_memberAddress, memberAddress.memberId, memberAddress.membershipType);
178     }
179 
180     /**
181     *@dev getter function to get all membersAccts
182     */
183     function getMembers() view public returns (address[]){
184         return membersAccts;
185     }
186     
187     /**
188     *@dev Get member information
189     *@param _memberAddress address to pull the memberId, membershipType and membership
190     */
191     function getMember(address _memberAddress) view public returns(uint, uint) {
192         return(members[_memberAddress].memberId, members[_memberAddress].membershipType);
193     }
194 
195     /**
196     *@dev Gets length of array containing all member accounts or total supply
197     */
198     function countMembers() view public returns(uint) {
199         return membersAccts.length;
200     }
201 
202     /**
203     *@dev Gets membership type
204     *@param _memberAddress address to view the membershipType
205     */
206     function getMembershipType(address _memberAddress) public constant returns(uint){
207         return members[_memberAddress].membershipType;
208     }
209     
210     /**
211     *@dev Allows the owner to set a new owner address
212     *@param _new_owner the new owner address
213     */
214     function setOwner(address _new_owner) public onlyOwner() { 
215         owner = _new_owner; 
216     }
217 
218     /**
219     *@dev Refund money if KYC/AML fails
220     *@param _to address to send refund
221     *@param _amount to refund. If no amount  is specified the current memberFee is refunded
222     */
223     function refund(address _to, uint _amount) public onlyOwner {
224         require (_to != address(0));
225         if (_amount == 0) {_amount = memberFee;}
226         removeMemberAcct(_to);
227         _to.transfer(_amount);
228         emit Refund(_to, _amount);
229     }
230 
231     /**
232     *@dev Allow owner to withdraw funds
233     *@param _to address to send funds
234     *@param _amount to send
235     */
236     function withdraw(address _to, uint _amount) public onlyOwner {
237         _to.transfer(_amount);
238     }    
239 }