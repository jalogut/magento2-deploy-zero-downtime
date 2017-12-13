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
@title[Demo]

[Demo]

---
@title[thank you]

##Thanks

 