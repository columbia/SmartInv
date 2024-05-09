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
12     function DaysTillUnlock () public constant returns (uint256 _days) {
13         if (now > unlockTime) {
14             return 0;
15         }
16         return (unlockTime - now) / 60 / 60 / 24;
17     }
18     
19     function SetOwner (address _newOwner) public {
20         require (msg.sender == owner);
21         owner = _newOwner; 
22     }  
23     
24     function SetUnlockTime (uint256 _time) public {
25         require (msg.sender == owner);
26         unlockTime = _time;
27     }
28     
29     function SetRecipient (address _recipient) public {
30         require (msg.sender == owner);
31         recipient = _recipient;
32     }
33     
34     function OpenGift () public {
35         require (msg.sender == recipient);
36         require (now >= unlockTime);
37         selfdestruct (recipient);
38     }
39 }