1 pragma solidity >=0.4.22 <0.6.0;
2 //Current version:0.5.2+commit.1df8f40c.Emscripten.clang
3 contract AnonymousWALL {
4     
5     address payable manager;
6     struct messageDetails {
7       uint time;
8       string headline ;
9       string message;
10     }
11     mapping (address => messageDetails) journal;
12     address[] private listofjournalists;
13     
14     constructor() public {
15       manager = msg.sender;
16     }
17     
18     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
19         if (_i == 0) {
20             return "0";
21         }
22         uint j = _i;
23         uint len;
24         while (j != 0) {
25             len++;
26             j /= 10;
27         }
28         bytes memory bstr = new bytes(len);
29         uint k = len - 1;
30         while (_i != 0) {
31             bstr[k--] = byte(uint8(48 + _i % 10));
32             _i /= 10;
33         }
34         return string(bstr);
35     }
36     
37     function enteranews(string memory uHeadline, string memory uMessage) public payable {
38         require(msg.value >= .001 ether,"This contrat works with minimum 0.001 ether");
39         require(journal[msg.sender].time == 0,"An account can only be used once.");
40         manager.transfer(msg.value);
41         journal[msg.sender].time = now;
42         journal[msg.sender].headline = uHeadline;
43         journal[msg.sender].message = uMessage;
44         listofjournalists.push(msg.sender) -1;
45     }
46     
47     function getjournalists() view public returns(address[] memory) {
48       return listofjournalists;
49     }
50     
51     function numberofnews() view public returns (uint) {
52       return listofjournalists.length;
53     }
54     
55     function gamessage(address _address) view public returns (string memory, string memory, string memory,string memory) {
56         if(journal[_address].time == 0){
57             return ("0", "0", "0", "This address hasnt sent any messages before.");
58         } else {
59             return (uint2str(journal[_address].time), journal[_address].headline, journal[_address].message, "We reached your message successfully.");
60         }
61     }
62 }