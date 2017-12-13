@title[Introduction]
## Fully automated zero downtime
##### <span style="font-family:Helvetica Neue; font-weight:bold">deployments in <span style="color:#f46f25">Magento 2.2</span></span>

---?image=assets/img/about-me.png
@title[About me]

---
@title[Agenda 0]
## Agenda

* Project Setup
* Wrong deployment
* Right deployment
* Zero Downtime
* Build Pipeline
* CI
* Issues

---
@title[Agenda 1]
## Agenda

* **Project Setup**
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>
* <span style="opacity: 0.2;">Issues</span>

@fa[arrow-down]

+++
@title[Project Setup]

<ul>
<li>git (or another VCS)</li>
<li class="fragment">composer</li>
<li class="fragment">vendor **out** of VCS</li>
<li class="fragment">app/etc/env  **out** of VCS</li>
<li class="fragment">app/etc/config.php **included** in VCS</li>
<li class="fragment">composer.lock **included** in VCS</li>
</ul>

+++
@title[Proper Magento 2 Composer Setup]
#### Proper Magento 2 Composer Setup

<br>

Tutorial: [https://blog.hauri.me/proper-magento2-composer-setup.html](https://blog.hauri.me/proper-magento2-composer-setup.html)

---
@title[Agenda 2]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* **Wrong deployment**
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>
* <span style="opacity: 0.2;">Issues</span>

@fa[arrow-down]

+++
#### Manually

<br>

[Demo]

+++
#### Manually

<br>

- Waste of time |
- Easy to make mistakes |
- High Downtime: 15min - 30min |

+++
#### Simple Automation

<br>

[Demo]

+++
#### Simple Automation

<br>

- Not reliable |
- High Downtime: 15min - 30min |

---
@title[Agenda 3]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* **Right deployment**
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>
* <span style="opacity: 0.2;">Issues</span>

@fa[arrow-down]

+++
@title[Right Deployment]
#### Right deployment

<br>

![Relase Symlink](assets/img/release_symlink.png)

+++
@title[Tools]

#### Tools

<br>

- [Deployer (PHP)](https://deployer.org/)
- [Capistrano (Ruby)](http://capistranorb.com/)
- [Shipit-deploy (Node-js)](https://github.com/shipitjs/shipit-deploy)

+++
@title[Demo Right Deployment]

[Demo]

+++
#### Pros

<br>

- Fully automated |
- Reliable |
- Low Downtime: ~20sec |

---
@title[Agenda 4]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* **Zero Downtime**
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>
* <span style="opacity: 0.2;">Issues</span>

@fa[arrow-down]

+++
@title[Maintenance needed]
#### Maintenance needed

<br>

- setup:upgrade
- config:import

+++
@title[Skip maintenance]
#### Skip them if not needed = no maintenance = 0 downtime

+++
@title[Demo zero downtime]

[Demo] 
<!--
First show in local, how the commands reacts when editing module.xml version and config.php
Later update the deploy.sh to skip maintenance
Mention that setup:upgrade always runs config:import, so if the first is needed we do not need to execute config:import again
Show PR link
-->

+++
@title[Zero downtime commands]

- setup:db:status
- config:import:status (Magento >= 2.2.3)

+++
@title[Zero downtime accomplished]

#### Zero Downtime accomplished!
![Emoji Rock](assets/img/emoji_rock.png)

---
@title[Agenda 5]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* **Build Pipeline**
* <span style="opacity: 0.2;">CI</span>
* <span style="opacity: 0.2;">Issues</span>

@fa[arrow-down]

+++

Config Propagation

+++

Possible to compile and generate assets w/o DB

+++

Docs config:import:dump (only static config... haha) It dumps everything (we'll see later how to overcome that)

+++

Show config.php example (my example with only static config). Thanks to that we can build all project files in a separated server.

+++

Pipeline image

+++

Crossed Pipeline image -> .tar and transfer to artefacts server or via scp

+++

[Demo] (move to build.sh. [static-deploy -f] deploy.sh unzips only)

+++ 

#### Pros

<br>

* Spare CPU usage on live server during deployment
* Keep archive in something like S3 or Nexus for history, back in time checks or auditing.
* For CI systems where you release first to stage/test and later same archive to the Prod server
<!-- See after minute 8:55 http://deploy.lo/video/deploy-zip/ -->
* Fancy deployment AWS can automatically deploy builds using load balancers 

---
@title[Agenda 6]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* **CI**
* <span style="opacity: 0.2;">Issues</span>

+++

Jenkins tutorial

+++ 

Jenkinsfile example "code directly in slide"

+++ 

[Video]

<!-- edit file, tag, push, Blue ocean, server updated 0 downtime -->

---
@title[Agenda 7]
## Agenda

* <span style="opacity: 0.2;">Project Setup</span>
* <span style="opacity: 0.2;">Wrong deployment</span>
* <span style="opacity: 0.2;">Right deployment</span>
* <span style="opacity: 0.2;">Zero Downtime</span>
* <span style="opacity: 0.2;">Build Pipeline</span>
* <span style="opacity: 0.2;">CI</span>
* **Tips - Issues - Workaounds**

+++

#### TIPS!

* build and deploy in a repo, so you share it among all projects. Only properties on the project level. (show how to move the properties)
* (db backup before setup:upgrade)
* disable modules if needed
* clean up old releases and backups
* release unique name for develop branch, if we want to continuously update our dev server with the latest status of develop
* cron:update

+++

#### Issues and Workarounds!

* config:import:dump (gist until PR approved)
* config:import:status (workaroung until PR approved)
* Local $_ENV for urls and shared settings
* static-deploy language command one by one
* static-deploy options not working
* Rollbacks



---
@title[thank you]

##Thanks

 