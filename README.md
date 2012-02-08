Gitcycle
========

Tame your development cycle.

About
-----

Gitcycle is a `git` wrapper that makes working on a team easy.

It assumes you are using pull requests along side [GitHub Issues](https://github.com/features/projects/issues).

It connects to email, Lighthouse, and Campfire if you want it to.

Get Started
-----------

Visit [gitcycle.com](http://gitcycle.com) to set up your repository.

gitc
----

The `gitc` command does everything `git` does, but with some extra features.

Try using `gitc` for everything. It should just work.

Branch From Ticket
------------------

First, checkout the branch that you will eventually merge your code into:

	gitc checkout [BRANCH]

Type `gitc branch` + your ticket URL to create a new branch:

	gitc branch https://xxx.lighthouseapp.com/projects/0000/tickets/0000-my-ticket

Pull
----

Use `gitc pull` without parameters. It knows what you're trying to do.

	gitc pull

If you're working on a ticket branch, it will automatically pull the latest code from upstream.

Commit
------

Commit all changes and open commit message in EDITOR:

	gitc commit

Ticket number and name are prefilled if present.

Push
----

Use `gitc push` without parameters. It knows what you're trying to do.

	gitc push

Discuss
-------

After pushing some commits, put the code up for discussion:

	gitc discuss

Ready
-----

When the branch is ready for code review:

	gitc ready

This will label the pull request as "Pending Review".

Code Review
-----------

Periodically check for "Pending Review" issues on GitHub.

### Pass

	gitc review pass [GITHUB ISSUE #] [...]

Label the issue "Pending QA".

### Fail

	gitc review fail [GITHUB ISSUE #] [...]

Label the issue "Fail".

Quality Assurance
-----------------

Periodically check for "Pending QA" issues on Github.

### Create QA Branch

	gitc qa [GITHUB ISSUE #] [...]

Now you have a QA branch containing all commits from the specified Github issue numbers.

### Fail

	gitc qa fail [GITHUB ISSUE #]

Label the issue with "Fail" and regenerate the QA branch without the failing issue.

### Pass

	gitc qa pass

Label all issues "Pass" and the merge the QA branch into target branch.

### Status

See who is QA'ing what:

	gitc qa

Checkout
--------

### Upstream Branch

If you are working in a fork, it is easy to checkout upstream branches:

	gitc checkout [BRANCH]

### Collaborate

Checkout branches from other forks:

	gitc checkout [USER] [BRANCH]

Todo
----

* Label issues with ticket milestone
* Add ability to associate multiple branches/pull requests with one Lighthouse ticket
* Add comment on lighthouse with issue URL
* gitc discuss should tag issue with 'Discuss'
* On pass or fail, send email to Github email
* Note you can use gitc with a string
* gitc qa pass, should not set ticket to pending-approval if its already resolved
* If gitc redo happens on branch with Github issue, close the existing issue
* Add comment on lighthouse with issue URL
* Instead of detecting CONFLICT, use error status $? != 0
* gitc qa pass # since we're changing this to pass all the tickets, we need to loop through all the merged issues and update the lighthouse state to pending-qa
* There's still a Tagging Issue I tried to fix parseLabel http://d.pr/8eOS , Pass should remove Pending *, but remove the Branch Name.  Also, when I gitc reviewed failed [issue number] it marks it pending-qa and failed.. not correct.  I'll take a look at this over the weekend -Tung
* gitc discuss should tag issue with 'Discuss'
* gitc ready - possibly do syntax checks
$ gitc st - shortcut
* issues aren't assigned to people
* There's still a Tagging Issue I tried to fix parseLabel http://d.pr/8eOS , Pass should remove Pending, but remove the Branch Name