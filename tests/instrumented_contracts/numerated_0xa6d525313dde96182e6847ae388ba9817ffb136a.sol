1 /*  
2     Subscrypto
3     Copyright (C) 2019 Subscrypto Team
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 */
18 
19 pragma solidity 0.5.2;
20 
21 contract SubscryptoMeta {
22 
23     uint constant MIN_SUBSCRIPTION_DAI_CENTS = 100;
24 
25     event Register(address indexed receiver);
26 
27     struct SubscriptionTemplate {
28         bytes32     slug;
29         string      name;
30         string      description;
31         string      url;
32         uint        daiCents;        // 32 bytes
33         address     receiver;        // 20 bytes
34         uint32      interval;        //  4 bytes
35     }
36 
37     mapping (address => SubscriptionTemplate) public subscriptions;
38     mapping (bytes32 => SubscriptionTemplate) public subscriptionsBySlug;
39 
40 
41     function registerSubscription(
42         bytes32 slug, 
43         string calldata name, 
44         string calldata description, 
45         string calldata url,
46         uint daiCents, 
47         uint32 interval) external 
48     {
49         require(daiCents >= MIN_SUBSCRIPTION_DAI_CENTS, "Subsciption amount too low");
50         require(interval >= 86400, "Interval must be at least 1 day");
51         require(interval <= 31557600, "Interval must be at most 1 year");
52         require(subscriptionsBySlug[slug].daiCents == 0 || subscriptionsBySlug[slug].receiver == msg.sender, "Slug is already reserved");
53 
54         subscriptions[msg.sender] = SubscriptionTemplate(slug, name, description, url, daiCents, msg.sender, interval);
55         subscriptionsBySlug[slug] = subscriptions[msg.sender];
56 
57         emit Register(msg.sender);
58     }
59 
60     function unregisterSubscription() external {
61         require(subscriptions[msg.sender].daiCents > 0, "No subcription found for address");
62         delete subscriptionsBySlug[subscriptions[msg.sender].slug];
63         delete subscriptions[msg.sender];
64     }
65 
66 }