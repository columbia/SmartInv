1 contract BirthdayGift {
2     
3     address public owner = 0x770F34Fdd214b36f2494ed57bb827B4c319E5BaA;
4     address public recipient = 0x6A93e96E999326eB02f759EaF5d4e71d0a8653e8;
5     
6     // 5 Apr 2023 00:00:00 PST | 5 Apr 2023 08:00:00 GMT
7     uint256 public unlockTime = 1680681600; 
8     
9     function BirthdayGift () public {
10     }
11     
12     function () payable public {}
13     
14     function DaysTillUnlock () public constant returns (uint256 _days) {
15         if (now > unlockTime) {
16             return 0;
17         }
18         return (unlockTime - now) / 60 / 60 / 24;
19     }
20     
21     function SetOwner (address _newOwner) public {
22         require (msg.sender == owner);
23         owner = _newOwner; 
24     }  
25     
26     function SetUnlockTime (uint256 _time) public {
27         require (msg.sender == owner);
28         unlockTime = _time;
29     }
30     
31     function SetRecipient (address _recipient) public {
32         require (msg.sender == owner);
33         recipient = _recipient;
34     }
35     
36     function OpenGift () public {
37         require (msg.sender == recipient);
38         require (now >= unlockTime);
39         selfdestruct (recipient);
40     }
41 }