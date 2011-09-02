from fabric.operations import get, put
from fabric.api import task, run, env
from . import secrets

@task
def backup():
    "retrieve an SQL dump of webpad/jsbin data"

    run('mysqldump -u jsbin -p%(jsbin_pw)s jsbin > jsbin.sql' % secrets)
    get('jsbin.sql', 'jsbin.%(host)s.dump.sql')
    run('rm jsbin.sql')

@task
def restore(filename=None):
    "restore a previous SQL dump of webpad/jsbin data"
    
    if filename is None:
        filename = 'jsbin.%(host)s.dump.sql' % env
    put(filename, 'jsbin.sql')
    run('mysql -u jsbin -p%(jsbin_pw)s jsbin < jsbin.sql' % secrets)
    run('rm jsbin.sql')