This ruby app was written for Ruby 2.0. It'll probably work in Ruby 1.9 and 1.8, but no guarantees.

To execute the application, just run `./bin/baseballers`

To execute the specs, install rspec and run `rspec`

Considerations:
- I could have grouped the seasons under teams as well
- I considered putting each row of the CSV into a Season object. It would have allowed some more convenience in method naming/calling, but I didn't have time to refactor that.
- According to my math, there are several batters that had a 1.00 batting average, but they only had one or two at-bats. Filtering for people with over 500 at bats, still yielded one player with a higher batting average than miguel cabrera (for the triple crown). 550 at bats knocked him out.