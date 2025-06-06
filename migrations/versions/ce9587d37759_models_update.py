"""models update

Revision ID: ce9587d37759
Revises: f61145571bc4
Create Date: 2025-03-30 15:11:13.012399

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'ce9587d37759'
down_revision: Union[str, None] = 'f61145571bc4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint('quiz_results_user_id_fkey', 'quiz_results', type_='foreignkey')
    op.drop_column('quiz_results', 'user_id')
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('quiz_results', sa.Column('user_id', sa.INTEGER(), autoincrement=False, nullable=False))
    op.create_foreign_key('quiz_results_user_id_fkey', 'quiz_results', 'users', ['user_id'], ['id'])
    # ### end Alembic commands ###
