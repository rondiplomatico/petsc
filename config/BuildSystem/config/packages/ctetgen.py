import config.package
import os

class Configure(config.package.GNUPackage):
  def __init__(self, framework):
    config.package.GNUPackage.__init__(self, framework)
    self.gitcommit         = '6d01158'
    self.giturls           = ['https://bitbucket.org/petsc/ctetgen.git']
    self.download          = ['http://ftp.mcs.anl.gov/pub/petsc/externalpackages/ctetgen-0.4.tar.gz']
    self.functions         = []
    self.includes          = []
    return

  def setupDependencies(self, framework):
    config.package.GNUPackage.setupDependencies(self, framework)
    self.petscdir       = framework.require('PETSc.options.petscdir', self.setCompilers)
    return

  def Install(self):
    return self.installDir

  def configureLibrary(self):
    ''' Just assume the downloaded library will work'''
    self.checkDownload()
    self.include = [os.path.join(self.installDir,'include')]
    self.lib     = [os.path.join(self.installDir,'lib','libctetgen.a')]
    self.found   = 1
    self.dlib    = self.lib
    if not hasattr(self.framework, 'packages'):
      self.framework.packages = []
    self.framework.packages.append(self)

  def postProcess(self):
    try:
      self.logPrintBox('Compiling Ctetgen; this may take several minutes')
      # uses the regular PETSc library builder and then moves result 
      output,err,ret  = config.package.GNUPackage.executeShellCommand('cd '+self.packageDir+' && '+self.make.make+' PETSC_DIR='+self.petscdir.dir+' clean lib',timeout=1000, log = self.log)
      self.log.write(output+err)
      self.logPrintBox('Installing Ctetgen; this may take several minutes')
      self.installDirProvider.printSudoPasswordMessage(1)
      output,err,ret  = config.package.GNUPackage.executeShellCommand('cd '+self.packageDir+' && '+self.installDirProvider.installSudo+self.make.make+' PETSC_DIR='+self.petscdir.dir+' install-ctetgen',timeout=1000, log = self.log)
      self.log.write(output+err)
    except RuntimeError, e:
      raise RuntimeError('Error running make on Ctetgen: '+str(e))


