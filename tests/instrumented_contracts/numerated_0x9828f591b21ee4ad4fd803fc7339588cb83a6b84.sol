1 /// Simple contract that collects money, keeps them till the certain birthday
2 /// time and then allows certain recipient to take the collected money.
3 contract BirthdayGift {
4     /// Address of the recipient allowed to take the gift after certain birthday
5     /// time.
6     address public recipient;
7 
8     /// Birthday time, the gift could be taken after.
9     uint public birthday;
10 
11     /// Congratulate recipient and give the gift.
12     ///
13     /// @param recipient recipient of the gift
14     /// @param value value of the gift
15     event HappyBirthday (address recipient, uint value);
16 
17     /// Instantiate the contract with given recipient and birthday time.
18     ///
19     /// @param _recipient recipient of the gift
20     /// @param _birthday birthday time
21     function BirthdayGift (address _recipient, uint _birthday)
22     {
23         // Remember recipient
24         recipient = _recipient;
25 
26         // Remember birthday time
27         birthday = _birthday;
28     }
29 
30     /// Collect money if birthday time didn't come yet.
31     function ()
32     {
33         // Do not collect after birthday time
34         if (block.timestamp >= birthday) throw;
35     }
36 
37     /// Take a gift.
38     function Take ()
39     {
40         // Only proper recipient is allowed to take the gift
41         if (msg.sender != recipient) throw;
42 
43         // Gift couldn't be taken before birthday time
44         if (block.timestamp < birthday) throw;
45 
46         // Let's congratulate our recipient
47         HappyBirthday (recipient, this.balance);
48 
49         // And finally give the gift!
50         if (!recipient.send (this.balance)) throw;
51     }
52 }