# -*- coding: utf-8 -*-
import click

from sample import __version__


@click.command()
@click.pass_context
def version_command(context):
    """
    Print out version information.
    """
    click.echo("sveetch-python-sample {}".format(__version__))
