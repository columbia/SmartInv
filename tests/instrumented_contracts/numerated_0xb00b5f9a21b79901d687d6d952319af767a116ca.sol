1 pragma solidity ^0.4.0;
2 contract FileHost {
3     uint256 version;
4     uint256[] data; //Byte arrays take up a lot more space than they need to.
5     address master;
6     string motd;
7     string credit;
8     bool lock;
9     
10     function FileHost() public {
11         //Store the master.
12         master = msg.sender;
13         version = 5;
14         motd = "";
15         credit = "to 63e190e32fcae9ffcca380cead85247495cc53ffa32669d2d298ff0b0dbce524 for creating the contract";
16         lock = false;
17     }
18     function newMaster(address newMaster) public {
19         require(msg.sender == master);
20         master = newMaster;
21     }
22     function addData(uint256[] newData) public {
23         //Append data
24         require(msg.sender == master);
25         require(!lock);
26         for (var i = 0; i < newData.length; i++) {
27             data.push(newData[i]);
28         }
29     }
30     function resetData() public {
31         //Set the data, also useful for clearing the data.
32         require(msg.sender == master);
33         require(!lock);
34         delete data;
35     }
36     function setMotd(string newMotd) public {
37         //For communicating with the common butters.
38         require(msg.sender == master);
39         motd = newMotd;
40     }
41     function getData() public returns (uint256[]) {
42         //Get the data, shouldn't need to be ran on the network as the data is stored locally on the blockchain.
43         return data;
44     }
45     function getSize() public returns (uint) {
46         //Get the size, shouldn't need to be ran on the network as the data is stored locally on the blockchain.
47         return data.length;
48     }
49     function getMotd() public returns (string) {
50         //Get the message for the common butter.
51         return motd;
52     }
53     function getVersion() public returns (uint) {
54         //Get the contract version
55         return version;
56     }
57     function getCredit() public returns (string) {
58         //Who gets credit for the contract.
59         return credit;
60     }
61     function lockFile() public {
62         //Prevent further changes
63         assert(msg.sender == master);
64         lock = true;
65     }
66     function withdraw() public {
67         //Withdraw any donations.
68         assert(msg.sender == master);
69         master.transfer(this.balance);
70     }
71 }