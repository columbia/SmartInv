1 contract ChineseCookies {
2 
3         address[] bakers;
4         mapping(address => string[]) cookies;
5         mapping(string => string) wishes;
6 
7         function ChineseCookies() {
8                 bakeCookie("A friend asks only for your time not your money.");
9                 bakeCookie("If you refuse to accept anything but the best, you very often get it.");
10                 bakeCookie("A smile is your passport into the hearts of others.");
11                 bakeCookie("A good way to keep healthy is to eat more Chinese food.");
12                 bakeCookie("Your high-minded principles spell success.");
13                 bakeCookie("Hard work pays off in the future, laziness pays off now.");
14                 bakeCookie("Change can hurt, but it leads a path to something better.");
15                 bakeCookie("Enjoy the good luck a companion brings you.");
16                 bakeCookie("People are naturally attracted to you.");
17                 bakeCookie("A chance meeting opens new doors to success and friendship.");
18                 bakeCookie("You learn from your mistakes... You will learn a lot today.");
19         }
20 
21         function bakeCookie(string wish) {
22                 var cookiesCount = cookies[msg.sender].push(wish);
23 
24                 // if it's the first cookie then we add sender to bakers list
25                 if (cookiesCount == 1) {
26                         bakers.push(msg.sender);
27                 }
28         }
29 
30         function breakCookie(string name) {
31                 var bakerAddress = bakers[block.number % bakers.length];
32                 var bakerCookies = cookies[bakerAddress];
33 
34                 wishes[name] = bakerCookies[block.number % bakerCookies.length];
35         }
36 }