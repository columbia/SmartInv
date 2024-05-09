1 pragma solidity ^0.5.0;
2 
3 /** 
4   * @title Remember Jeju 4.3 Tragedy 
5   * @author Sooyoung Hyun
6   * @notice You can use this contract to create online memorial database based on smart contracts.
7   * @dev For more implementation details read the "README.md" document. 
8   */
9 contract Remember43 {
10     
11     mapping(uint16 => Victim) public victims;
12     mapping(address => bool) public isContributor;
13     
14     uint16 public victimsCount;
15     address owner;
16     uint timeout = 20 minutes;
17     
18     modifier onlyOwner {
19         require(owner == msg.sender);
20         _;
21     }
22     
23     modifier onlyContributor {
24         require(isContributor[msg.sender]);
25         _;
26     }
27     
28     struct Victim {
29         uint16 idx;
30         string name;
31         string addr;
32         uint createTime;
33     }
34     
35     event contributorSet(address indexed contributor, bool state);
36     event victimAdded(uint16 idx, string name, string addr, uint createTime);
37     event victimModified(uint16 idx, string name, string addr, uint createTime);
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42     
43     /**
44       * @notice Set contributor's state true or false.
45       * @dev Only owner can use this function to change contributor's state. 
46       * @param _addr User address for updating state.
47       * @param _state True or false for updating state.
48       */
49     function setContributor(address _addr, bool _state) onlyOwner public {
50         isContributor[_addr] = _state;
51         emit contributorSet(_addr, isContributor[_addr]);
52     }
53     
54     /**
55       * @notice Add victim to storage.
56       * @dev Only owner and contributor can use this function to add victim to storage.
57       * @param _name Name of victim.
58       * @param _addr Local address of victim.
59       */
60     function addVictim(string memory _name, string memory _addr) onlyContributor public {
61         victimsCount++;
62         Victim memory vt = Victim(victimsCount, _name, _addr, now);
63         victims[victimsCount] = vt;
64         emit victimAdded(victims[victimsCount].idx, victims[victimsCount].name, victims[victimsCount].addr, victims[victimsCount].createTime);
65     }
66     
67     /**
68       * @notice Get victim infomation.
69       * @dev Function used in frontend to get the user infomation.
70       * @param _idx Request index for providing infomation.  
71       * @return _idx User index of requests.
72       * @return vt.name User name of requests.
73       * @return vt.addr User local address of requests.
74       */
75     function getVictim(uint16 _idx) public view returns(uint16, string memory, string memory) {
76         Victim memory vt = victims[_idx]; 
77         return (_idx, vt.name, vt.addr); 
78     }
79     
80     /**
81       * @notice Modify victim infomation.
82       * @dev Only owner and contributor can use this function to modify victim infomation.
83       * @dev It can be modified only within the time limit.
84       * @param _idx Index of victim.
85       * @param _name Name of victim.
86       * @param _addr Local address of victim.
87       */
88     function modifyVictim(uint16 _idx, string memory _name, string memory _addr) onlyContributor public {
89         require(victims[_idx].createTime + timeout > now);
90         victims[_idx].name = _name;
91         victims[_idx].addr = _addr;
92         emit victimModified(victims[_idx].idx, victims[_idx].name, victims[_idx].addr, victims[_idx].createTime);
93         
94     }
95 }